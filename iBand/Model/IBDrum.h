//
//  IBDrum.h
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBInstruments.h"
#import "BBGroove.h"

typedef enum IBDrumType {
    IBDrumTypeBassDrum = 0,
    IBDrumTypeSnare = 1,
    IBDrumTypeHiHat = 2
} IBDrumType;

static NSUInteger const DEFAULT_TEMPO = 120;
static NSUInteger const DEFAULT_BEATS = 4;



@protocol IBDrumDelegate <NSObject>
@optional
- (void)didTick:(NSUInteger)tick;
- (void)didUpdateTempoTo:(NSUInteger)newTempo;
- (void)didUpdateModel;
@end



@interface IBDrum : IBInstruments

@property (nonatomic, strong ,readonly) NSArray *drumSet;
@property (nonatomic, readonly) BBGrooverBeat currentBeats;
@property (nonatomic, readonly) BOOL isLoaded;
@property (nonatomic) NSUInteger tempo;

- (void)turnOnDrum:(IBDrumType)type atIndex:(NSUInteger)index;
- (void)turnOffDrum:(IBDrumType)type atIndex:(NSUInteger)index;
- (void)updateTempo:(NSUInteger)tempo;

- (void)start;
- (void)stop;
- (void)resume;
- (void)pause;

@property (nonatomic, weak) IBOutlet id <IBDrumDelegate> delegate;
+ (IBDrum *)sharedInstance;

@end