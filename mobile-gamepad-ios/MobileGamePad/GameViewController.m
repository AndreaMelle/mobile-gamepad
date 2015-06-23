//
//  GameViewController.m
//  VrCtrl2
//
//  Created by Andrea Melle on 10/03/2015.
//  Copyright (c) 2015 Happy Finish. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GamePadEventHandler.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@interface GameViewController()
{
    IBOutlet UIButton *settingsBtn;
    GameScene *scene;
    OSCGamePadEventHandler *eventHandler;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *receiverip = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"receiverip"];
    
    if (receiverip == nil)
    {
        receiverip = @"192.168.1.154";
        [[NSUserDefaults standardUserDefaults] setObject:receiverip forKey:@"receiverip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    eventHandler = [[OSCGamePadEventHandler alloc] init];
    [eventHandler setIPAddress:receiverip];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        scene = [GameScene unarchiveFromFile:@"GameScene"];
        
        [scene setEventHandler:eventHandler];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        skView.multipleTouchEnabled = YES;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
}

- (IBAction)OnSettingsBtn:(id)sender
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"IP Address" message:@"Enter Receiver IP Address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    NSString *receiverip = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"receiverip"];
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = receiverip;
    
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",buttonIndex);
    
    if (buttonIndex == 1)
    {
        UITextField *ip = [alertView textFieldAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:ip.text forKey:@"receiverip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [eventHandler setIPAddress:ip.text];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
