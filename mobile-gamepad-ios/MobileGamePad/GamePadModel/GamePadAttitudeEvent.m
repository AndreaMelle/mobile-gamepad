//
//  GamePadAttitudeEvent.m
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "GamePadAttitudeEvent.h"

@implementation GamePadAttitudeEvent
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize w = _w;

+ (instancetype)CreateWithX:(CGFloat)x AndY:(CGFloat)y AndZ:(CGFloat)z AndW:(CGFloat)w;
{
    GamePadAttitudeEvent *evt = [[GamePadAttitudeEvent alloc] initWithX:x
                                                                   AndY:y
                                                                   AndZ:z
                                                                   AndW:w];
    
    return evt;
}

- (instancetype)initWithX:(CGFloat)inx AndY:(CGFloat)iny AndZ:(CGFloat)inz AndW:(CGFloat)inw;
{
    self = [super init];
    if(self)
    {
        _x = inx;
        _y = iny;
        _z = inz;
        _w = inw;
    }
    return self;
}

- (F53OSCMessage*)toOSCMessage
{
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/attitude"
                                                            arguments:@[
                                                                        [NSNumber numberWithFloat:_x],
                                                                        [NSNumber numberWithFloat:_y],
                                                                        [NSNumber numberWithFloat:_z],
                                                                        [NSNumber numberWithFloat:_w],
                                                                        ]];
    return message;
}

@end
