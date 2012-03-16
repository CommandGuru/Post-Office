//
//  AppDelegate.m
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
//#import "SPLocationManager.h"

@implementation AppDelegate
@synthesize navigationController = _navigationController;

@synthesize window = _window, mainViewController=_mainViewController, splashViewController=_splashViewController;

- (id)init
{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(locationManagerUpdateLocationCompleteNotification:) 
//                                                     name:SPLocationManagerUpdateLocationCompleteNotification 
//                                                   object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(locationManagerUpdateLocationFailNotification:) 
//                                                     name:SPLocationManagerUpdateLocationFailNotification 
//                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
  [_window release];
  [_mainViewController release];
  [_splashViewController release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[SPLocationManager sharedLocationManager] startUpdatingLocation];
    
    self.window = [[[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];

    // Override point for customization after application launch.
    _splashViewController = [[AVRUISplashViewController alloc] init];
    [_splashViewController setDelegate: self];
    
    _mainViewController = [[MainViewController alloc] initWithNibName: @"MainViewController" 
                                                               bundle: nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: _mainViewController];
//    self.navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = _splashViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - AVRUISplashViewControllerDelegate Methods

- (UIViewController *)segueViewControllerInSplashViewController:(AVRUISplashViewController *)controller
{
  return _navigationController;
}

- (NSUInteger)numberOfAnimationsInSplashViewController:(AVRUISplashViewController *)controller
{
  return 1;
}

- (CAAnimation *)animationAtIndex:(NSUInteger)index inSplashViewController:(AVRUISplashViewController *)controller
{
    CABasicAnimation *animation = [CABasicAnimation animation];

    [animation setDuration:0.8];

    switch (index) {
        case 0:
            [animation setFromValue:(id)[UIColor blackColor].CGColor];
            [animation setToValue:(id)[UIColor clearColor].CGColor];
            [animation setKeyPath:@"backgroundColor"];
            break;
    }
    
    return animation;
}

//- (void)splashViewControllerDidStartAnimations:(AVRUISplashViewController *)controller
//{
//    NSLog(@"splashViewControllerDidStartAnimations:");
//}
//
//- (void)splashViewControllerDidCompleteAnimations:(AVRUISplashViewController *)controller
//{
//    NSLog(@"splashViewControllerDidCompleteAnimations:");
//}
//
//- (void)splashViewController:(AVRUISplashViewController *)controller didStartAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index
//{
//    NSLog(@"splashViewController:didStartAnimation:");
//}
//
//- (void)splashViewController:(AVRUISplashViewController *)controller didCompleteAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index
//{
//    NSLog(@"splashViewController:didCompleteAnimation:");
//}

#pragma mark - SPLocationManager Notifications

- (void)locationManagerUpdateLocationCompleteNotification:(NSNotification *)n
{
    NSLog(@"locationManagerUpdateLocationCompleteNotification:");
}

- (void)locationManagerUpdateLocationFailNotification:(NSNotification *)n
{
    NSLog(@"locationManagerUpdateLocationFailNotification:");
}


#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation
{
  return [[_mainViewController facebook] handleOpenURL: url];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url 
{
  return [[_mainViewController facebook] handleOpenURL: url]; 
}

@end
