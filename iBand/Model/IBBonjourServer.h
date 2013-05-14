//
//  IBBonjourServer.h
//  iBand
//
//  Created by Li QIAN on 5/8/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "DTBonjourServer.h"

@interface IBBonjourServer : DTBonjourServer

- (id)initWithNone;

@property (nonatomic, readonly) NSString *identifier;

@end
