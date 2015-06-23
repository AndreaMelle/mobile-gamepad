//
//  GamePadButtonEvent.m
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "GamePadButtonEvent.h"

@implementation GamePadButtonEvent
@synthesize buttonDown = _buttonDown;

+ (instancetype)CreateWithDownState:(BOOL)isDown;
{
    GamePadButtonEvent *evt = [[GamePadButtonEvent alloc] initWithDownState:isDown];
    return evt;
}

- (instancetype)initWithDownState:(BOOL)isDown;
{
    self = [super init];
    if(self)
    {
        _buttonDown = isDown;
    }
    return self;
}

- (F53OSCMessage*)toOSCMessage
{
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/button"
                                                            arguments:@[
                                                                        [NSNumber numberWithBool:_buttonDown]
                                                                        ]];
    return message;
}

@end
