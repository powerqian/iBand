//
//  IBNetworkHelper.h
//  iBand
//
//  Created by Li QIAN on 5/8/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBBonjourClient.h"
#import "IBBonjourServer.h"
#import "InstrumentList.h"

@protocol IBNetworkHelperDelegate <NSObject>
- (void)didUpdateBonjourDeviceList;
@end

@interface IBNetworkHelper : NSObject
<NSNetServiceDelegate, NSNetServiceBrowserDelegate,
DTBonjourServerDelegate,DTBonjourDataConnectionDelegate>

- (void)startBonjour;
- (void)updateInstrument:(IBInstrumentType)instrument withInfo:(NSDictionary *)dic;

@property (nonatomic, readonly, strong) NSArray *deviceList;
@property (nonatomic, weak) id <IBNetworkHelperDelegate> delegate;
+ (IBNetworkHelper *)helper;
@end
