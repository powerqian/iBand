//
//  IBDrumViewController.m
//  iBand
//
//  Created by Li QIAN on 5/2/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBDrumViewController.h"
#import "IBNetworkInstrumentInterface.h"
#import "BBGridView.h"
#import "BBTickView.h"

@interface IBDrumViewController () <BBGridViewDelegate, BBGridViewDataSource, BBTickViewDelegate>
@property (weak, nonatomic) IBOutlet BBGridView *bbGridView;
@property (weak, nonatomic) IBOutlet BBTickView *bbTickView;
@property (weak, nonatomic) IBOutlet UISlider *tempoSlider;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;
@property (nonatomic, strong) IBDrum *drum;
@end

@implementation IBDrumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.drum = [IBDrum sharedInstance];
    self.drum.delegate = self;
    if (!self.drum.isLoaded) [self.drum load];
    
    self.bbGridView.delegate = self;
    self.bbGridView.datasource = self;
    self.bbTickView.delegate = self;
    
    self.tempoSlider.value = self.drum.tempo;
    [self updateTempo:self.drum.tempo];
}

#pragma mark - IPDrumDelegate
- (void)didTick:(NSUInteger)tick
{
    NSLog(@"Current tick:%lu",(unsigned long)tick);
    self.bbTickView.currentTick = tick;
    [self.bbTickView setNeedsLayout];
}

- (void)didUpdateTempoTo:(NSUInteger)newTempo
{
    self.tempoSlider.value = newTempo;
    self.tempoLabel.text = [NSString stringWithFormat:@"Tempo: %d", newTempo];
}

- (void)didUpdateModel
{
    [self.bbGridView setNeedsDisplay];
}

- (void)didStop
{
    self.bbTickView.currentTick = 0;
    [self.bbTickView setNeedsLayout];
}

#pragma mark -
#pragma mark BBGridViewDataSource Methods
- (NSUInteger)gridView:(BBGridView *)gridView columnsForRow:(NSUInteger)row
{
    return [self.drum.drumSet[row] subdivision];
}

- (NSUInteger)rowsForGridView:(BBGridView *)gridView
{
    return [self.drum.drumSet count];
}

#pragma mark BBGridViewDelegate Methods
- (void)gridView:(BBGridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    BBVoice *voice = self.drum.drumSet[row];
    
    if ([voice.values[column] boolValue]) {
        [self.drum turnOffDrum:row atIndex:column];
    } else {
        [self.drum turnOnDrum:row atIndex:column];
    }
    [IBNetworkInstrumentInterface sendDrumUpdateWithDrumType:row atIndex:column isOn:[voice.values[column] boolValue]];
    
    [gridView setNeedsDisplay];
}

- (BOOL)gridView:(BBGridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    return [[self.drum.drumSet[row] values][column] boolValue];
}

#pragma mark BBTickViewDelegate methods
- (NSUInteger)ticksForTickView:(BBTickView *)tickView {
    return self.drum.currentBeats;
}
#pragma mark -

#pragma mark Helper Methods
- (void)updateTempo:(NSUInteger)tempo {
    self.tempoLabel.text = [NSString stringWithFormat:@"Tempo = %d", tempo];
}

#pragma mark IBActions
- (IBAction)sliderFinished:(UISlider *)sender {
    NSUInteger newTempo = sender.value;
    self.drum.tempo = newTempo;
    [self updateTempo:newTempo];

    [IBNetworkInstrumentInterface sendDrumUpdateWithTempo:newTempo];
}
- (IBAction)sliderChanged:(UISlider *)sender {
    self.tempoLabel.text = [NSString stringWithFormat:@"Tempo = %d", (NSUInteger)sender.value];
}

- (IBAction)startTapped:(id)sender {
    [self.drum start];
    [IBNetworkInstrumentInterface sendDrumUpdateWithStartOrStop:YES];
}

- (IBAction)stopTapped:(id)sender {
    [self.drum stop];
    [IBNetworkInstrumentInterface sendDrumUpdateWithStartOrStop:NO];
}

@end
