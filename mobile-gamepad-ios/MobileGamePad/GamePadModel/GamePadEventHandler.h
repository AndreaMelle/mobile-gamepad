//
//  GamePadEventHandler.h
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <SceneKit/SceneKit.h>
#import "F53OSC.h"

@protocol GamePadEvent <NSObject>

- (F53OSCMessage*)toOSCMessage;

@end

@protocol GamePadEventHandler <NSObject>

- (void)pushEventToQueue:(id<GamePadEvent>)evt;
- (void)update;

@end
