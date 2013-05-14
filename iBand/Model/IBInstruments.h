//
//  IBInstruments.h
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OALSimpleAudio.h"

@interface IBInstruments : NSObject

- (void)load; //Abstract method. Probably will block thread.

@end
