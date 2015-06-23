//
//  GamePadButtonEvent.h
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePadEventHandler.h"

@interface GamePadButtonEvent : NSObject<GamePadEvent>

+ (instancetype)CreateWithDownState:(BOOL)isDown;
- (instancetype)initWithDownState:(BOOL)isDown;
- (F53OSCMessage*)toOSCMessage;

@property (nonatomic) BOOL buttonDown;

@end
