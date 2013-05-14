//
//  IBPianoViewController.m
//  iBand
//
//  Created by Li QIAN on 5/2/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBPianoViewController.h"
#import "IBNetworkInstrumentInterface.h"
#import "KeyboardView.h"
#import "OctaveRangeSelectionView.h"

@interface IBPianoViewController () <KeyboardViewDelegate, OctaveRangeDelegate, OctaveRangeDataSource>

@property (weak, nonatomic) IBOutlet KeyboardView *keyboard;
@property (weak, nonatomic) IBOutlet OctaveRangeSelectionView *octaveRange;

@property (nonatomic, readonly) NSRange storedRange;
@end

@implementation IBPianoViewController

- (NSRange)storedRange
{
    NSRange range =  NSMakeRange([[NSUserDefaults standardUserDefaults] integerForKey:(NSString *)KEY_RANGE_LOCATION],
                                 [[NSUserDefaults standardUserDefaults] integerForKey:(NSString *)KEY_RANGE_LENGTH]);
    if (range.location == 0 || range.length == 0) {
        range = INITIAL_KEY_RANGE;
    }
    return range;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboard.delegate = self;
    self.octaveRange.delegate = self;
    self.octaveRange.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboard.visibleKeyRange = self.storedRange;
}

#pragma mark - KeyViewDelegate
- (void)keysPressed:(NSSet *)keys {
    NSLog(@"keysPressed=%d", [keys count]);
    
    for (NSNumber* keyIndex in keys) {
        NSLog(@"Preseed key is:%@",keyIndex);
        [[IBPiano sharedInstance] playKeyAtIndex:[keyIndex unsignedIntegerValue]];
        [IBNetworkInstrumentInterface sendPianoUpdateWithKeyIndex:[keyIndex unsignedIntegerValue] isOn:YES];
    }
}

static NSString const *KEY_RANGE_LOCATION = @"Range.Location";
static NSString const *KEY_RANGE_LENGTH = @"Range.Length";

#pragma mark - OctaveRangeSelectionViewDelegate
- (void)rangeChanged:(NSRange)newRange {
    NSLog(@"Got new range %d, %d", newRange.location, newRange.length);
    [[NSUserDefaults standardUserDefaults] setInteger:newRange.location forKey:(NSString *)KEY_RANGE_LOCATION];
    [[NSUserDefaults standardUserDefaults] setInteger:newRange.length forKey:(NSString *)KEY_RANGE_LENGTH];
    
    [self.keyboard setVisibleKeyRange:newRange];
    [self.keyboard setNeedsLayout];
}

- (NSRange)initialRange
{
    return self.storedRange;
}

@end
