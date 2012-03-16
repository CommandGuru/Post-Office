//
//  AVRUISplashViewController.h
//  AVRUIKit
//
//  Created by Andrea Gelati on 10/4/10.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "UIView+ScreenCapture.h"

@protocol AVRUISplashViewControllerDelegate;

@interface AVRUISplashViewController : UIViewController 
{
    NSUInteger _currentAnimationIndex; // return the index of the current (playing) animation.
    NSUInteger _animationCount; // return the animations count provided by the delegate.
}

@property (nonatomic, assign) id<AVRUISplashViewControllerDelegate> delegate;

@end

@protocol AVRUISplashViewControllerDelegate <NSObject>
- (NSUInteger)numberOfAnimationsInSplashViewController:(AVRUISplashViewController *)controller;
- (CAAnimation *)animationAtIndex:(NSUInteger)index inSplashViewController:(AVRUISplashViewController *)controller;
@optional
- (UIViewController *)segueViewControllerInSplashViewController:(AVRUISplashViewController *)controller;
- (void)splashViewControllerDidStartAnimations:(AVRUISplashViewController *)controller;
- (void)splashViewControllerDidCompleteAnimations:(AVRUISplashViewController *)controller;
- (void)splashViewController:(AVRUISplashViewController *)controller didStartAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index;
- (void)splashViewController:(AVRUISplashViewController *)controller didCompleteAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index;
@end
    