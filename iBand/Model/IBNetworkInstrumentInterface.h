//
//  IBNetworkInstrumentInterface.h
//  iBand
//
//  Created by Li QIAN on 5/9/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBNetworkHelper.h"
#import "IBDrum.h"
#import "IBPiano.h"

@interface IBNetworkInstrumentInterface : NSObject
+ (void)updateInstrumentWithDic:(NSDictionary *)updateDic;
+ (void)sendDrumUpdateWithDrumType:(IBDrumType)type atIndex:(NSUInteger)index isOn:(BOOL)isOn;
+ (void)sendDrumUpdateWithTempo:(NSUInteger)tempo;
+ (void)sendDrumUpdateWithStartOrStop:(BOOL)start;

+ (void)sendPianoUpdateWithKeyIndex:(NSUInteger)index isOn:(BOOL)isOn;
@end
