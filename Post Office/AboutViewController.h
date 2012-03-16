//
//  AboutViewController.h
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 
{
    UIButton *backButton;

    IBOutlet UILabel *nameAppLabel;
    IBOutlet UILabel *versionLabel;
    IBOutlet UITableView *aboutTableView;
   
    NSDictionary *keys;
	NSArray *sections;
	NSString *index;

}

@property (nonatomic, retain) UIBarButtonItem *backButtonItem;

@property (nonatomic, retain) IBOutlet UILabel *nameAppLabel;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;
@property (nonatomic, retain) IBOutlet UITableView *aboutTableView;

@property (nonatomic, retain)  NSDictionary *keys;
@property (nonatomic, retain)  NSArray *sections;
@property (nonatomic, retain)  NSString *index;

- (void)goBack:(id)sender;

@end
