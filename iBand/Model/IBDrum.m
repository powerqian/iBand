//
//  IBDrum.m
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBDrum.h"

@interface IBDrum () <BBGrooverDelegate>
@property (nonatomic, strong) BBGroover *groover;
@end

@implementation IBDrum
@synthesize tempo = _tempo;

- (NSUInteger)tempo
{
    return self.groover.groove.tempo;
}

- (void)setTempo:(NSUInteger)tempo
{
    if (_tempo != tempo) {
        _tempo = tempo;
        self.groover.groove.tempo = tempo;
    }
}

- (NSArray *)drumSet
{
    return self.groover.groove.voices;
}

- (BBGrooverBeat)currentBeats
{
    return self.groover.currentSubdivision;
}

#pragma mark - Public APIs
// Implementation of super class
- (void)load
{
    [super load];
    _isLoaded = YES;
    BBGroove *groove = [BBGroove groove];
    groove.tempo = DEFAULT_TEMPO;
    groove.beats = DEFAULT_BEATS;
    groove.beatUnit = BBGrooverBeatQuarter;
    
    BBVoice *bass = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    BBVoice *snare = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare.wav";
    
    BBVoice *hihat = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"hihat.wav";
    
    groove.voices = @[ bass, snare, hihat];
    
    self.groover = [BBGroover grooverWithGroove:groove];
    self.groover.delegate = self;
    
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
}

- (void)turnOnDrum:(IBDrumType)type atIndex:(NSUInteger)index
{
    BBVoice *drumSound = self.groover.groove.voices[type];
    [drumSound setValue:YES forIndex:index];
}

- (void)turnOffDrum:(IBDrumType)type atIndex:(NSUInteger)index
{
    BBVoice *drumSound = self.groover.groove.voices[type];
    [drumSound setValue:NO forIndex:index];
}

- (void)updateTempo:(NSUInteger)tempo
{
    self.groover.groove.tempo = tempo;
    if ([self.delegate respondsToSelector:@selector(didUpdateTempoTo:)]) {
        [self.delegate didUpdateTempoTo:tempo];
    }
}

- (void)start
{
    [self.groover startGrooving];
}

- (void)stop
{
    [self.groover stopGrooving];
}

- (void)resume
{
    [self.groover resumeGrooving];
}

- (void)pause
{
    [self.groover pauseGrooving];
}


#pragma mark - BBGrooverDelegate Methods
- (void) groover:(BBGroover *)sequencer didTick:(NSUInteger)tick {
    if ([self.delegate respondsToSelector:@selector(didTick:)]) {
        [self.delegate didTick:tick];
    }
}

- (void) groover:(BBGroover *)sequencer voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
}

#pragma mark - Singleton
//Singleton using GCD
+ (IBDrum *)sharedInstance
{
    static IBDrum *sharedIBDrum = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIBDrum = [[self alloc] init];
    });
    return sharedIBDrum;
}

@end
