//
//  GamePadJoystickEvent.m
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "GamePadJoystickEvent.h"

@implementation GamePadJoystickEvent
@synthesize joystickNormalizedX = _joystickNormalizedX;
@synthesize joystickNormalizedY = _joystickNormalizedY;
@synthesize joystickNormalizedPower = _joystickNormalizedPower;

+ (instancetype)CreateWithNormalizedX:(CGFloat)nx AndNormalizedY:(CGFloat)ny AndNormalizedPower:(CGFloat)npower
{
    GamePadJoystickEvent *evt = [[GamePadJoystickEvent alloc] initWithNormalizedX:nx
                                                                   AndNormalizedY:ny
                                                               AndNormalizedPower:npower];
    
    return evt;
}

- (instancetype)initWithNormalizedX:(CGFloat)nx AndNormalizedY:(CGFloat)ny AndNormalizedPower:(CGFloat)npower
{
    self = [super init];
    if(self)
    {
        _joystickNormalizedX = nx;
        _joystickNormalizedY = ny;
        _joystickNormalizedPower = npower;
    }
    return self;
}

- (F53OSCMessage*)toOSCMessage
{
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/joystick"
                                                            arguments:@[
                                                                        [NSNumber numberWithFloat:_joystickNormalizedX],
                                                                        [NSNumber numberWithFloat:_joystickNormalizedY],
                                                                        [NSNumber numberWithFloat:_joystickNormalizedPower]
                                                                        ]];
    return message;
}

@end
