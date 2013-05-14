//
//  IBBonjourServer.m
//  iBand
//
//  Created by Li QIAN on 5/8/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBBonjourServer.h"
#import "OpenUDID.h"

@implementation IBBonjourServer

static NSString const *SERVICE_NAME = @"_iBand._tcp";

- (NSString *)identifier
{
    return [OpenUDID value];
}

- (id)initWithNone
{
    self = [super initWithBonjourType:(NSString *)SERVICE_NAME];
    
    if (self)
    {
        [self _updateTXTRecord];
    }
    
    return self;
}

- (void)_updateTXTRecord
{
	self.TXTRecord = @{@"ID" : self.identifier};
}

- (void)connection:(DTBonjourDataConnection *)connection didReceiveObject:(id)object
{
	// need to call super because this forwards the object to the server delegate
	[super connection:connection didReceiveObject:object];
	
    //	// we need to pass the object to all other connections so that they also see the messages
    //	for (DTBonjourDataConnection *oneConnection in self.connections)
    //	{
    //		if (oneConnection!=connection)
    //		{
    //			[oneConnection sendObject:object error:NULL];
    //		}
    //	}
}

@end
