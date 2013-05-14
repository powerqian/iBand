//
//  IBPiano.m
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBPiano.h"

@interface IBPiano()
@property (nonatomic, strong) NSArray *keys;
@end

@implementation IBPiano

#pragma mark - Public APIs
// Implementation of super class
- (void)load
{
    [super load];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"keyboardLayout" ofType:@"plist"];
    self.keys = [NSArray arrayWithContentsOfFile:plistPath];
    
    // Load Audio
    for (int i = 0; i < [self.keys count]; i++) {
        [[OALSimpleAudio sharedInstance] preloadEffect:[NSString stringWithFormat:@"%@.aif",self.keys[i]]];
    }
    
}

- (void)playKeyAtIndex:(NSUInteger)index
{
    NSLog(@"Play Key Index:%lu", (unsigned long)index);
    if ([self.keys count] > index) {
        [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%@.aif",self.keys[index]]];
    } else {
        NSLog(@"Unable to play key: %lu",(unsigned long)index);
    }
}

#pragma mark - Singleton
+ (IBPiano *)sharedInstance
{
    static IBPiano *sharedIBPiano = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIBPiano = [[self alloc] init];
    });
    return sharedIBPiano;
}


@end
