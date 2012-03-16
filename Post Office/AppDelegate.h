//
//  AppDelegate.h
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVRUISplashViewController.h"

@class MainViewController; /*SPLocationManager */;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVRUISplashViewControllerDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (nonatomic, strong) AVRUISplashViewController *splashViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
