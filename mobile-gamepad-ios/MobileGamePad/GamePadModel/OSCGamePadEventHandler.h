//
//  OSCGamePadEventHandler.h
//  SpacePadCtrl
//
//  Created by Andrea Melle on 23/06/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePadEventHandler.h"

@interface OSCGamePadEventHandler : NSObject<GamePadEventHandler>

- (void)pushEventToQueue:(id<GamePadEvent>)evt;
- (void)update;
- (void)setIPAddress:(NSString*)ip;

@end
