//
//  GameScene.h
//  VrCtrl2
//

//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GamePadEventHandler.h"
#import "OSCGamePadEventHandler.h"

@interface GameScene : SKScene

@property (nonatomic, weak) OSCGamePadEventHandler *eventHandler;

@end
