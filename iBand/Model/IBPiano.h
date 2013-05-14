//
//  IBPiano.h
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBInstruments.h"

@interface IBPiano : IBInstruments

- (void)playKeyAtIndex:(NSUInteger)index;

+ (IBPiano *)sharedInstance;

@end
