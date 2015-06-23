//
//  GamePadJoystickEvent.h
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePadEventHandler.h"

@interface GamePadJoystickEvent : NSObject<GamePadEvent>

+ (instancetype)CreateWithNormalizedX:(CGFloat)nx AndNormalizedY:(CGFloat)ny AndNormalizedPower:(CGFloat)npower;
- (instancetype)initWithNormalizedX:(CGFloat)nx AndNormalizedY:(CGFloat)ny AndNormalizedPower:(CGFloat)npower;
- (F53OSCMessage*)toOSCMessage;

@property (nonatomic) CGFloat joystickNormalizedX;
@property (nonatomic) CGFloat joystickNormalizedY;
@property (nonatomic) CGFloat joystickNormalizedPower;

@end
