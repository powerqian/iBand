//
//  IBNetworkInstrumentInterface.m
//  iBand
//
//  Created by Li QIAN on 5/9/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBNetworkInstrumentInterface.h"
#import "InstrumentList.h"

@implementation IBNetworkInstrumentInterface

static NSString const * KEY_INSTRUMENT  = @"Instrument";
static NSString const * KEY_ON_OFF  = @"On_Off";
static NSString const * KEY_DRUM_START_STOP  = @"Start_Stop";
static NSString const * KEY_DRUM_TYPE  = @"Drum Type";
static NSString const * KEY_DRUM_INDEX  = @"Drum Index";
static NSString const * KEY_DRUM_TEMPO  = @"Drum Tempo";
static NSString const * KEY_PIANO_KEY_INDEX  = @"Piano Key Index";

+ (void)updateInstrumentWithDic:(NSDictionary *)updateDic
{
    if ([updateDic[KEY_INSTRUMENT] isEqualToString:DRUM]) {
        IBDrum *drum = [IBDrum sharedInstance];
        if ([[updateDic allKeys] containsObject:KEY_DRUM_TEMPO]) {
            [drum updateTempo:[updateDic[KEY_DRUM_TEMPO] intValue]];
        } else if ([[updateDic allKeys] containsObject:KEY_DRUM_START_STOP]) {
            BOOL start = [updateDic[KEY_DRUM_START_STOP] boolValue];
            if (start) {
                [drum start];
            } else {
                [drum stop];
                [drum.delegate didStop];
            }
        } else {
            NSUInteger drumType = [updateDic[KEY_DRUM_TYPE] intValue];
            NSUInteger index    = [updateDic[KEY_DRUM_INDEX] intValue];
            if ([updateDic[KEY_ON_OFF] boolValue]) {
                [drum turnOnDrum:drumType atIndex:index];
            } else {
                [drum turnOffDrum:drumType atIndex:index];
            }
            if ([drum.delegate respondsToSelector:@selector(didUpdateModel)]) {
                [drum.delegate didUpdateModel];
            }
        }
    } else if ([updateDic[KEY_INSTRUMENT] isEqualToString:PIANO]) {
        [[IBPiano sharedInstance] playKeyAtIndex:[updateDic[KEY_PIANO_KEY_INDEX] unsignedIntegerValue]];
    }
}

+ (void)sendDrumUpdateWithDrumType:(IBDrumType)type atIndex:(NSUInteger)index isOn:(BOOL)isOn
{
    NSDictionary *sendDic = @{KEY_INSTRUMENT: DRUM,
                              KEY_ON_OFF    : @(isOn),
                              KEY_DRUM_TYPE : @(type),
                              KEY_DRUM_INDEX: @(index) };
    [[IBNetworkHelper helper] updateInstrument:IBInstrumentDrum withInfo:sendDic];
}

+ (void)sendDrumUpdateWithTempo:(NSUInteger)tempo
{
    [[IBNetworkHelper helper] updateInstrument:IBInstrumentDrum withInfo:@{KEY_INSTRUMENT : DRUM, KEY_DRUM_TEMPO : @(tempo)} ];
}

+ (void)sendDrumUpdateWithStartOrStop:(BOOL)start
{
    [[IBNetworkHelper helper] updateInstrument:IBInstrumentDrum withInfo:@{KEY_INSTRUMENT : DRUM, KEY_DRUM_START_STOP : @(start)}];
}

+ (void)sendPianoUpdateWithKeyIndex:(NSUInteger)index isOn:(BOOL)isOn
{
    NSDictionary *sendDic = @{KEY_INSTRUMENT        : PIANO,
                              KEY_ON_OFF            : @(isOn),
                              KEY_PIANO_KEY_INDEX   : @(index) };
    [[IBNetworkHelper helper] updateInstrument:IBInstrumentPiano withInfo:sendDic];
}

@end
