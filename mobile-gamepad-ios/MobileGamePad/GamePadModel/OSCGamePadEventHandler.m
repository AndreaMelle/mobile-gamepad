//
//  OSCGamePadEventHandler.m
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "OSCGamePadEventHandler.h"

@interface OSCGamePadEventHandler()
{
    F53OSCClient *oscClient;
}

@property (nonatomic, strong) NSMutableArray *eventQueue;

@end

@implementation OSCGamePadEventHandler

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _eventQueue = [[NSMutableArray alloc] init];
        
        oscClient = [[F53OSCClient alloc] init];
        //[oscClient setHost:@"192.168.1.154"];
        NSString *receiverip = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"receiverip"];
        [oscClient setHost:receiverip];
        [oscClient setPort:4325];
        
    }
    
    return self;
}

- (void)setIPAddress:(NSString*)ip
{
    [oscClient setHost:ip];
}

- (void)pushEventToQueue:(id<GamePadEvent>)evt
{
    F53OSCMessage *message = [evt toOSCMessage];
    [_eventQueue addObject:message];
}

- (void)update
{
    for(F53OSCMessage* message in _eventQueue)
    {
        [oscClient sendPacket:message];
    }
    
    [_eventQueue removeAllObjects];
}

@end
