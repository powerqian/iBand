//
//  IBNetworkHelper.m
//  iBand
//
//  Created by Li QIAN on 5/8/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBNetworkHelper.h"
#import "IBNetworkInstrumentInterface.h"

@interface IBNetworkHelper()
@property (nonatomic, strong) IBBonjourClient *client;
@property (nonatomic, strong) IBBonjourServer *server;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, strong) NSMutableSet *unidentifiedServices;
@property (nonatomic, strong) NSMutableArray *foundServices;
@property (nonatomic, strong) NSMutableArray *createdServers;
@property (nonatomic, strong) NSMutableArray *activeServicesIndex;
@property (nonatomic, strong) NSMutableArray *clientLists;

@end

@implementation IBNetworkHelper

- (NSArray *)deviceList
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[self.foundServices count]];
    for (NSNetService *service in self.foundServices) {
        [list addObject:service.name];
    }
    return list;
}

static NSString const *SERVICE_NAME = @"_iBand._tcp";

#pragma mark - Public API
- (void)startBonjour
{
    //*********** Property Initialize start ***********
    self.unidentifiedServices = [[NSMutableSet alloc] init];
    self.foundServices = [[NSMutableArray alloc] init];
    self.createdServers = [[NSMutableArray alloc] init];
    
    //*********** Bonjour start ***********
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.delegate = self;
    [self.serviceBrowser searchForServicesOfType:(NSString *)SERVICE_NAME inDomain:@""];
    //Bonjour end
    
    //*********** DTBonjour start ***********
    self.server = [[IBBonjourServer alloc] initWithNone];
    [self.createdServers addObject:self.server];
    self.server.delegate = self;
    [self.server start];
    //DTBonjour end
}

static NSString const * KEY_IDENTIFIER  = @"Identifier";

- (void)updateInstrument:(IBInstrumentType)instrument withInfo:(NSDictionary *)dic
{
    IBBonjourServer *localServer = (IBBonjourServer *)[self.createdServers lastObject];
    //    NSString *localName = [(NSNetService *)localServer name];
    NSString *localId = localServer.identifier;
    NSMutableDictionary *dicToAdd = [dic mutableCopy];
    [dicToAdd addEntriesFromDictionary:@{KEY_IDENTIFIER : localId}]; //KEY_USER: localName,
    NSDictionary *completeNoteInfo = [NSDictionary dictionaryWithDictionary:dicToAdd];
    for (NSNetService *server in self.foundServices) {
        for (IBBonjourClient *client in self.clientLists) {
            NSError *error;
            if (![client sendObject:completeNoteInfo error:&error]) {
                NSLog(@"Sending error: %@",error);
            }
        }
    }
    
}

#pragma mark - DTBonjourServer Delegate (Server)

- (void)bonjourServer:(DTBonjourServer *)server didReceiveObject:(id)object onConnection:(DTBonjourDataConnection *)connection
{
    //TODO, Did receive new data
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *info = (NSDictionary *)object;
        NSString *identifierOfNoteInfo = info[KEY_IDENTIFIER];
        
        for (NSNetService *service in self.foundServices) {
            NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
            NSString *identifier = [[NSString alloc] initWithData:dict[@"ID"] encoding:NSUTF8StringEncoding];
            
            if ([identifier isEqualToString:identifierOfNoteInfo]) {
                //                NSNumber *indexNumber = @([self.foundServices indexOfObject:service]);
                //                [self.activeServicesIndex addObject:indexNumber];
                NSLog(@"Active identifier: %@",identifier);
            }
        }
        [IBNetworkInstrumentInterface updateInstrumentWithDic:info];
    }
}


#pragma mark - Lazy Initializer

- (NSMutableArray *)activeServicesIndex
{
    if (!_activeServicesIndex) {
        _activeServicesIndex = [[NSMutableArray alloc] init];
    }
    return _activeServicesIndex;
}

- (NSMutableArray *)clientLists
{
    if (!_clientLists) {
        _clientLists = [[NSMutableArray alloc] init];
    }
    return _clientLists;
}

#pragma mark - Private Methods of Bonjour Related

- (BOOL)_isLocalServiceIdentifier:(NSString *)identifier
{
	for (IBBonjourServer *server in self.createdServers)
	{
		if ([server.identifier isEqualToString:identifier])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)_updateFoundServices
{
	BOOL didUpdate = NO;
    
	for (NSNetService *service in [self.unidentifiedServices copy])
	{
		NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
		
		if (!dict)
		{
			continue;
		}
		
		NSString *identifier = [[NSString alloc] initWithData:dict[@"ID"] encoding:NSUTF8StringEncoding];
		
		if (![self _isLocalServiceIdentifier:identifier])
		{
			[self.foundServices addObject:service];
            //            self.service = service; //TODO
            NSLog(@"updateService: %@", service);
			didUpdate = YES;
            
            IBBonjourClient *client = [[IBBonjourClient alloc] initWithService:service];
            client.delegate = self;
            [client open];
            [self.clientLists addObject:client];
		}
		
		[self.unidentifiedServices removeObject:service];
	}
	
    if (didUpdate)
    {
        [self.delegate didUpdateBonjourDeviceList];
    }
}

#pragma mark - NetServiceBrowser Delegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    aNetService.delegate = self;
    [aNetService startMonitoring];
    
    [self.unidentifiedServices addObject:aNetService];
    
    NSLog(@"found: %@", aNetService);
    
    if (!moreComing) {
        [self _updateFoundServices];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    [self.foundServices removeObject:aNetService];
	[self.unidentifiedServices removeObject:aNetService];
    
	NSLog(@"removed: %@", aNetService);
    
	if (!moreComing)
	{
        [self.delegate didUpdateBonjourDeviceList];
	}
}

#pragma mark - NSNetService Delegate
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
	[self _updateFoundServices];
	[sender stopMonitoring];
}

#pragma mark - Singleton using GCD
+ (IBNetworkHelper *)helper
{
    static IBNetworkHelper *defaultHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultHelper = [[self alloc] init];
    });
    return defaultHelper;
}
//

@end
