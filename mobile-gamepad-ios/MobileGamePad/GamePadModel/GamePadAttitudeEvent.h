//
//  GamePadAttitudeEvent.h
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GamePadEventHandler.h"

@interface GamePadAttitudeEvent : NSObject<GamePadEvent>

+ (instancetype)CreateWithX:(CGFloat)x AndY:(CGFloat)y AndZ:(CGFloat)z AndW:(CGFloat)w;
- (instancetype)initWithX:(CGFloat)inx AndY:(CGFloat)iny AndZ:(CGFloat)inz AndW:(CGFloat)inw;
- (F53OSCMessage*)toOSCMessage;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat z;
@property (nonatomic) CGFloat w;

@end
