//
//  GameScene.m
//  VrCtrl2
//
//  Created by Andrea Melle on 10/03/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "GameScene.h"

#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "GamePadJoystickEvent.h"
#import "GamePadButtonEvent.h"
#import "GamePadAttitudeEvent.h"

#define MOTION_FREQUENCY (1.0f / 60.0f)

typedef enum
{
    TouchEventBegin,
    TouchEventMove,
    TouchEventEnd
} TouchEvent;

@interface GameScene ()
{
    SKNode *padNode;
    SKNode *buttonNode;
    
    SKSpriteNode *padBaseSprite;
    SKSpriteNode *padThumbSprite;
    SKSpriteNode *buttonSprite;
    SKSpriteNode *separatorSprite;
    
    CGFloat halfWidth;
    CGFloat MaxPadStretchSqrd;
    CGFloat MaxPadStretch;
    
    UITouch *leftTouch;
    UITouch *rightTouch;
    
    
    
    CMMotionManager *_motionManager;
    CMAttitude *_lastUpdate;
    
    SKTextureAtlas *padAtlas;
}

@end

@implementation GameScene
@synthesize eventHandler = _eventHandler;

-(void)didMoveToView:(SKView *)view
{
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = MOTION_FREQUENCY;
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    
    halfWidth = self.frame.size.width / 2.0f;
    leftTouch = nil;
    rightTouch = nil;
    
    padNode = [SKNode node];
    buttonNode= [SKNode node];
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    if(screenScale == 2.0f)
    {
        padAtlas = [SKTextureAtlas atlasNamed:@"Pad@2x"];
    }
    else if(screenScale == 3.0f)
    {
        padAtlas = [SKTextureAtlas atlasNamed:@"Pad@3x"];
    }
    else
    {
        padAtlas = [SKTextureAtlas atlasNamed:@"Pad"];
    }
    
    
    SKTexture *padBaseTex = [padAtlas textureNamed:@"padBase"];
    SKTexture *padThumbTex = [padAtlas textureNamed:@"padThumb"];
    SKTexture *buttonTex = [padAtlas textureNamed:@"button"];
    SKTexture *separatorTex = [padAtlas textureNamed:@"separator"];
    
    padBaseSprite = [SKSpriteNode spriteNodeWithTexture:padBaseTex];
    padThumbSprite = [SKSpriteNode spriteNodeWithTexture:padThumbTex];
    buttonSprite = [SKSpriteNode spriteNodeWithTexture:buttonTex];
    separatorSprite = [SKSpriteNode spriteNodeWithTexture:separatorTex];
    
    [padBaseSprite setScale:screenScale];
    [padThumbSprite setScale:screenScale];
    [buttonSprite setScale:screenScale];
    [separatorSprite setScale:screenScale];
    
    [padNode addChild:padBaseSprite];
    [padNode addChild:padThumbSprite];
    [buttonNode addChild:buttonSprite];
    
    
    padNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    buttonNode.position = CGPointMake(CGRectGetMidX(self.frame) + 200,
                                           CGRectGetMidY(self.frame));
    
    separatorSprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame) - 75.0f);
    
    MaxPadStretchSqrd = padThumbSprite.size.width * padThumbSprite.size.width * 2;
    MaxPadStretch = sqrtf(MaxPadStretchSqrd);
    
    [self addChild:padNode];
    [self addChild:buttonNode];
    [self addChild:separatorSprite];
    
    [padNode setHidden:YES];
    [buttonNode setHidden:YES];
    
    [view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
    [view setMultipleTouchEnabled:YES];
}

- (void)handleJoystickForEvent:(TouchEvent)evt WithLocation:(CGPoint)location
{
    if (TouchEventBegin == evt)
    {
        padNode.position = location;
        padThumbSprite.position = CGPointMake(0, 0);
        [padNode setHidden:NO];
        
        [self.eventHandler pushEventToQueue:[GamePadJoystickEvent CreateWithNormalizedX:0
                                                                             AndNormalizedY:0
                                                                         AndNormalizedPower:0]];
        

    }
    else if(TouchEventMove == evt)
    {
        CGFloat sqrdDist = [self squaredDistanceWithP1:location AndP2:CGPointMake(0, 0)];
        CGFloat norm = sqrtf(sqrdDist);
        
        // event data
        CGFloat nx = location.x / norm;
        CGFloat ny = location.y / norm;
        CGFloat power = MIN(norm, MaxPadStretch) / MaxPadStretch;
        
        if(sqrdDist < MaxPadStretchSqrd)
        {
            padThumbSprite.position = location;
        }
        else
        {
            CGFloat x = nx * MaxPadStretch;
            CGFloat y = ny * MaxPadStretch;
            padThumbSprite.position = CGPointMake(x, y);
        }
        
        [self.eventHandler pushEventToQueue:[GamePadJoystickEvent CreateWithNormalizedX:nx
                                                                             AndNormalizedY:ny
                                                                         AndNormalizedPower:power]];
    }
    else if(TouchEventEnd == evt)
    {
        padNode.position = location;
        padThumbSprite.position = CGPointMake(0, 0);
        [padNode setHidden:YES];
        
        [self.eventHandler pushEventToQueue:[GamePadJoystickEvent CreateWithNormalizedX:0
                                                                             AndNormalizedY:0
                                                                         AndNormalizedPower:0]];
    }
    
    
}

- (void)handleButtonForEvent:(TouchEvent)evt WithLocation:(CGPoint)location
{
    if(TouchEventBegin == evt)
    {
        buttonNode.position = location;
        [buttonNode setHidden:NO];
        
        [self.eventHandler pushEventToQueue:[GamePadButtonEvent CreateWithDownState:YES]];
    }
    else if(TouchEventMove == evt)
    {
        
    }
    else if(TouchEventEnd == evt)
    {
        buttonNode.position = location;
        [buttonNode setHidden:YES];
        [self.eventHandler pushEventToQueue:[GamePadButtonEvent CreateWithDownState:NO]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL didFindLeft = NO;
    BOOL didFindRight = NO;
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        if(location.x < halfWidth && !didFindLeft)
        {
            didFindLeft = YES;
            
            if (leftTouch != nil)
            {
                [self handleJoystickForEvent:TouchEventEnd WithLocation:location];
                leftTouch = nil;
            }
            
            leftTouch = touch;
            [self handleJoystickForEvent:TouchEventBegin WithLocation:location];
        }
        else if(location.x > halfWidth && !didFindRight)
        {
            didFindRight = YES;
            
            if (rightTouch != nil)
            {
                [self handleButtonForEvent:TouchEventEnd WithLocation:location];
                rightTouch = nil;
            }
            
            rightTouch = touch;
            [self handleButtonForEvent:TouchEventBegin WithLocation:location];
        }
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL didFindLeft = NO;
    
    for (UITouch *touch in touches)
    {
        if(touch == leftTouch && !didFindLeft)
        {
            didFindLeft = YES;
            [self handleJoystickForEvent:TouchEventMove WithLocation:[touch locationInNode:padNode]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL didFindLeft = NO;
    BOOL didFindRight = NO;
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        if(touch == leftTouch && !didFindLeft)
        {
            didFindLeft = YES;
            [self handleJoystickForEvent:TouchEventEnd WithLocation:location];
            leftTouch = nil;
        }
        else if(touch == rightTouch && !didFindRight)
        {
            didFindRight = YES;
            [self handleButtonForEvent:TouchEventEnd WithLocation:location];
            rightTouch = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL didFindLeft = NO;
    BOOL didFindRight = NO;
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        if(touch == leftTouch && !didFindLeft)
        {
            didFindLeft = YES;
            [self handleJoystickForEvent:TouchEventEnd WithLocation:location];
            leftTouch = nil;
        }
        else if(touch == rightTouch && !didFindRight)
        {
            didFindRight = YES;
            [self handleButtonForEvent:TouchEventEnd WithLocation:location];
            rightTouch = nil;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    _lastUpdate = [[_motionManager deviceMotion] attitude];
    
    CGFloat qx = _lastUpdate.quaternion.x;
    CGFloat qy = _lastUpdate.quaternion.y;
    CGFloat qz = _lastUpdate.quaternion.z;
    CGFloat qw = _lastUpdate.quaternion.w;
    
    [self.eventHandler pushEventToQueue:[GamePadAttitudeEvent CreateWithX:qx AndY:qy AndZ:qz AndW:qw]];
    
    [self.eventHandler update];
}

- (CGFloat)squaredDistanceWithP1:(CGPoint)p1 AndP2:(CGPoint)p2
{
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = (xDist * xDist) + (yDist * yDist);
    return distance;
}

@end
