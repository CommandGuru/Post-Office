//
//  MainViewController.h
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface MainViewController : UIViewController <UITextViewDelegate,
                                                  UITabBarDelegate,
                                                  UITableViewDataSource,
                                                  FBRequestDelegate, 
                                                  FBDialogDelegate, 
                                                  FBSessionDelegate>
{
  Facebook *facebook;
}

@property (nonatomic, retain) UIBarButtonItem *settingsBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *postBarButtonItem;
@property (retain, nonatomic) IBOutlet UILabel *charactersCounter;
@property (nonatomic, retain) UIView *spinnerBackground;
@property (nonatomic, retain) UIActivityIndicatorView *postSendingProgressSpinner;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UISwitch *facebookSwitch;

#pragma mark - Actions

- (void)settingsBarButtonItemAction:(id)sender;
- (void)postBarButtonItemAction:(id)sender;
- (void)tweetUpdate:(NSString *) update;
- (void)postUpdate:(NSString *) update;
- (void)completePostOperations;

@end

