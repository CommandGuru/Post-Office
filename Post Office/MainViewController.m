//
//  MainViewController.m
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.//
//

//
// TODO Fix Facebook
// TODO Implement Twitter account existance check
//


#import "MainViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import "TwitterAccountViewController.h"
#import "FacebookAccountViewController.h"
#import "AboutViewController.h"

static NSString *fbAppId = @"105994639527932";
static const NSUInteger maxCharacters = 140;

static NSArray *facebookPermissions()
{
  static NSArray *permissions = nil;
  
  if (permissions == nil) {
    permissions = [[NSArray alloc] initWithObjects: @"read_stream",
                                                    @"friends_likes",
                                                    @"user_likes",
                                                    @"user_photos",
                                                    @"friends_photos",
                                                    @"publish_stream",
                                                    @"offline_access",
                                                    nil];
  }
  
  return permissions;
}


@interface MainViewController ()
{
  UIButton *postButton;
  UIButton *settingsButton;
  
  IBOutlet UITextView *postTextView;
  
  IBOutlet UILabel *settingsLabel;
    
  int sharedStopSpinnerIndicator;
  BOOL posttw;
  BOOL postfb;
  
  NSUserDefaults *defaults;
}

@end


@implementation MainViewController

@synthesize charactersCounter;
@synthesize settingsBarButtonItem = _settingsBarButtonItem;
@synthesize postBarButtonItem = _postBarButtonItem;
@synthesize spinnerBackground = _spinnerBackground;
@synthesize postSendingProgressSpinner = _postSendingProgressSpinner;
@synthesize facebook;
@synthesize twitterSwitch, facebookSwitch;

- (void)dealloc 
{
  [charactersCounter release];
  [super dealloc];
}

- (void)viewDidLoad
{
  id defEntry;
  
  [super viewDidLoad];
    

  // settings button
  _settingsBarButtonItem = [[UIBarButtonItem alloc] init];
//  UIImage *settingsImageNormal = [UIImage imageNamed: @"IcoSettingsOff.png"];
//  UIImage *settingsImageHighlighted = [UIImage imageNamed: @"IcoSettingsOn.png"];

  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Bkg.png"]];
  
  settingsLabel.text = NSLocalizedString(@"Settings", @"");
  
  defaults = [NSUserDefaults standardUserDefaults];

  defEntry = [defaults objectForKey: @"postTwitter"];
  posttw = defEntry ? [defEntry boolValue] : NO;
  defEntry = [defaults objectForKey: @"postFacebook"];
  postfb = defEntry ? [defEntry boolValue] : NO;
  
  facebook = [[Facebook alloc] initWithAppId: fbAppId andDelegate: self];

  if ([defaults objectForKey: @"FBAccessTokenKey"] 
      && [defaults objectForKey: @"FBExpirationDateKey"]) {
    facebook.accessToken = [defaults objectForKey: @"FBAccessTokenKey"];
    facebook.expirationDate = [defaults objectForKey: @"FBExpirationDateKey"];
  }  
  
  NSLog(@"postfb = %i", postfb);
  
  if (postfb && ([facebook isSessionValid] == NO)) {
    [facebook authorize: facebookPermissions()];
  }
}

- (void)viewWillAppear:(BOOL)animated 
{
  [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"TopBar.png"] 
                                                forBarMetrics: UIBarMetricsDefault];

  UIImage *settingsImageNormal = [UIImage imageNamed: @"IcoSettingsOn.png"];
  UIImage *settingsImageHighlighted = [UIImage imageNamed: @"IcoSettingsOff.png"];
  
  settingsButton = [UIButton buttonWithType: UIButtonTypeCustom];
  [settingsButton setFrame: CGRectMake(0, 0, settingsImageNormal.size.width, settingsImageNormal.size.height)];
  [settingsButton addTarget: self action: @selector(settingsBarButtonItemAction:) forControlEvents: UIControlEventTouchUpInside];
  [settingsButton setImage: settingsImageNormal forState: UIControlStateNormal];
  [settingsButton setImage: settingsImageHighlighted forState: UIControlStateHighlighted];
  settingsButton.enabled = NO;
  
  [_settingsBarButtonItem setCustomView: settingsButton];
  
  [[self.navigationController.navigationBar topItem] setLeftItemsSupplementBackButton: YES];
  
  [[self.navigationController.navigationBar topItem] setLeftBarButtonItem: _settingsBarButtonItem];
  
  // post button
  _postBarButtonItem = [[UIBarButtonItem alloc] init];
  UIImage *postImageNormal = [UIImage imageNamed: @"IcoMailOff.png"];
  UIImage *postImageHighlighted = [UIImage imageNamed: @"IcoMailOn.png"];
  postButton = [UIButton buttonWithType: UIButtonTypeCustom];
  [postButton setFrame: CGRectMake(0,0,postImageNormal.size.width,postImageNormal.size.height)];
  [postButton addTarget: self action: @selector(postBarButtonItemAction:) forControlEvents: UIControlEventTouchUpInside];
  [postButton setImage: postImageNormal forState: UIControlStateNormal];
  [postButton setImage: postImageHighlighted forState: UIControlStateHighlighted];
  [_postBarButtonItem setCustomView:postButton];
  [[self.navigationController.navigationBar topItem] setRightBarButtonItem: _postBarButtonItem];
  postButton.enabled = NO;
}

- (void)viewDidUnload
{
  [self setCharactersCounter:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)settingsBarButtonItemAction:(id)sender
{
  if ([postTextView isFirstResponder]) {
    [postTextView resignFirstResponder];
    settingsButton.enabled = NO;
  } 
}

- (void)postBarButtonItemAction:(id)sender
{
//  [postTextView resignFirstResponder];
//  settingsButton.enabled = YES;

  sharedStopSpinnerIndicator = 0;
  
  if (posttw) {
    sharedStopSpinnerIndicator++;
  }
  if (postfb) {
    sharedStopSpinnerIndicator++;
  }
    
  if (posttw || postfb) {
    _spinnerBackground = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    
    [_spinnerBackground setCenter: CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 3) - 44)];
    [_spinnerBackground setBackgroundColor: [UIColor blackColor]];
    [_spinnerBackground setAlpha: 0.7];
    _spinnerBackground.layer.cornerRadius = 15;
  
    if (_postSendingProgressSpinner == nil) {
      _postSendingProgressSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    [_postSendingProgressSpinner setHidesWhenStopped: YES];
    [_postSendingProgressSpinner setCenter: CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 3) - 44)];
    [_postSendingProgressSpinner setColor: [UIColor whiteColor]];
        
    [self.view addSubview: _spinnerBackground];
    [self.view addSubview: _postSendingProgressSpinner];
        
    [_postSendingProgressSpinner startAnimating];
    
    @try {
      if (postfb) {
        [self postUpdate: [postTextView text]];
      }
      if (posttw) {
        [self tweetUpdate: [postTextView text]];
      }      
    }
    @catch (NSException *exception) {
      UIAlertView *av = [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"An error has occurred", @"") 
                                                    message: NSLocalizedString(@"Please try again or send a new message.", @"") 
                                                   delegate: self 
                                          cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil] autorelease];
      [av show];
      
      [av release];
    }
  }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  NSUInteger ret = 0;
	
  switch(section) {
		case 0: // settings
			ret = 2;
      break;
      
		case 1:
			ret = 1;
			break;
	}

  return ret;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//  if (section == 0) {
//    return NSLocalizedString(@"Settings", nil);
//  }
//  
//  return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell *settingsTableViewCell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	
  if (settingsTableViewCell == nil) {
		settingsTableViewCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                    reuseIdentifier: cellIdentifier] autorelease];
	}
  
  switch ([indexPath section]) {
		case 0:
      settingsTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      switch ([indexPath row]) {
        case 0:
        {
          twitterSwitch = [[[UISwitch alloc] initWithFrame: CGRectZero] autorelease];
          
          [twitterSwitch setOn: posttw];
          settingsTableViewCell.accessoryView = twitterSwitch;
          
          [twitterSwitch addTarget: self action: @selector(flipTwitter:) forControlEvents: UIControlEventValueChanged];
          [[settingsTableViewCell textLabel] setText: NSLocalizedString(@"Twitter", @"")];
          settingsTableViewCell.imageView.image = [UIImage imageNamed: @"icon-twitter"];
          settingsTableViewCell.imageView.highlightedImage = [UIImage imageNamed: @"icon-twitter-pressed"];
        }
          break;
          
        case 1:
        {
          facebookSwitch = [[[UISwitch alloc] initWithFrame: CGRectZero] autorelease];

          [facebookSwitch setOn: postfb];
          settingsTableViewCell.accessoryView = facebookSwitch;
          
          [facebookSwitch addTarget: self action: @selector(flipFacebook:) forControlEvents: UIControlEventValueChanged];
          [[settingsTableViewCell textLabel] setText: NSLocalizedString(@"Facebook", @"")];
          settingsTableViewCell.imageView.image = [UIImage imageNamed: @"icon-facebook"];
          settingsTableViewCell.imageView.highlightedImage = [UIImage imageNamed: @"icon-facebook-pressed"]; 
        }
          break;
      }
      break;
      
    case 1:
      [settingsTableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      [[settingsTableViewCell textLabel] setText:NSLocalizedString(@"About", @"")];
      settingsTableViewCell.imageView.image = [UIImage imageNamed: @"icon-about"];
      settingsTableViewCell.imageView.highlightedImage = [UIImage imageNamed: @"icon-about-pressed"];            
      break;
	}	
  
	return settingsTableViewCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch([indexPath section]) {
		case 0: // settings
            switch ([indexPath row]) {
                case 0:
                {
//                    TwitterAccountViewController *t = [[TwitterAccountViewController alloc ] initWithNibName:@"TwitterAccountViewController" bundle:[NSBundle mainBundle]];
//                    [self.navigationController pushViewController:t animated:YES];
                    
                }
                    break;
                case 1:
                {
//                    FacebookAccountViewController *f = [[FacebookAccountViewController alloc] initWithNibName:@"FacebookAccountViewController" bundle:[NSBundle mainBundle]];
//                    [self.navigationController pushViewController:f animated:YES];
                }
                    break;
            }
            
			break;
		case 1:
        {
            AboutViewController *a = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController: a animated: YES];
        }
			break;
	}
}

#pragma mark - Flips


- (void)flipTwitter:(id)sender
{
  if (twitterSwitch.isOn) {
    // Check if the user has Twitter and want us to use it
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
      
    [store requestAccessToAccountsWithType: twitterAccountType withCompletionHandler: ^(BOOL granted, NSError *error) {
      if (granted == NO) {
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Attention", @"") 
                                  message: NSLocalizedString(@"User access to your account rejected. Please try again.", @"") 
                                                     delegate: self 
                                            cancelButtonTitle: @"Ok" 
                                            otherButtonTitles: nil] autorelease];
        [av show];
        
        [twitterSwitch setOn: NO animated: YES];
        posttw = NO;
        
      } else {
        // Grab the available accounts
        NSArray *twitterAccounts = [store accountsWithAccountType: twitterAccountType];
                           
        if ([twitterAccounts count] > 0) {
          // Use the first account for simplicity 
      //    ACAccount *twitterAccount = [twitterAccounts objectAtIndex: 0];
                               
          NSLog(@"User granted access to his Twitter accounts");
                               
          // TODO launch a fake or test requedt to find out if everything works fine with Twitter
          
        } else {
          UIAlertView *av = [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Add your Twitter Account", @"") 
                    message: NSLocalizedString(@"No Twitter Account found. Add an account to your iPhone Settings -> Twitter.", @"") 
                                                       delegate: self 
                                              cancelButtonTitle: @"Ok" 
                                              otherButtonTitles: nil] autorelease];
          [av show];
          
          [twitterSwitch setOn: NO animated: YES];
          posttw = NO;
        }
      } // if (granted) 
    }];
      
    posttw = YES;
    
  } else {
    posttw = NO;
  }

  [defaults setObject: [NSNumber numberWithBool: posttw] forKey: @"postTwitter"];
  [defaults synchronize];
}

- (void)flipFacebook:(id)sender
{
  if (facebookSwitch.isOn) {
    postfb = YES;
    
    if ([facebook isSessionValid] == NO) {
      [facebook authorize: facebookPermissions()];
    }
  } else {
    postfb = NO;
    
    if ([facebook isSessionValid]) {
      [facebook logout];
    }
  }

  [defaults setObject: [NSNumber numberWithBool: postfb] forKey: @"postFacebook"];
  [defaults synchronize];
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  if (postfb || posttw) {
    [postTextView becomeFirstResponder];
    settingsButton.enabled = YES;

    return YES;
    
  } else {
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Attention", @"") 
            message: NSLocalizedString(@"No accounts enabled. You need to enable at least one account to post a message.", @"") 
                                                 delegate: self 
                                        cancelButtonTitle: @"Ok" 
                                        otherButtonTitles: nil] autorelease];
    [av show];
  }
  
  return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  postButton.enabled = ([textView.text length] > 0);
}

- (void)textViewDidChange:(UITextView *)textView
{
  postButton.enabled = ([textView.text length] > 0);
  
  if ([textView.text length] > maxCharacters) {
    textView.text = [textView.text substringToIndex: maxCharacters];
  }
  
  self.charactersCounter.text = [NSString stringWithFormat: @"%d", [textView.text length]];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  postButton.enabled = NO;
}

- (void)tweetUpdate:(NSString *)message
{
  // Check if the user has Twitter and want us to use it
  ACAccountStore *store = [[ACAccountStore alloc] init];
  ACAccountType *twitterAccountType = 
  [store accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
  
  [store requestAccessToAccountsWithType: twitterAccountType withCompletionHandler: ^(BOOL granted, NSError *error) {
      if (granted == NO) {
         // The user rejected your request 
         NSLog(@"User rejected access to his account.");
        [self completePostOperations];

      } else {
       // Grab the available accounts
       NSArray *twitterAccounts = [store accountsWithAccountType: twitterAccountType];
       
       if ([twitterAccounts count] > 0) {
           // Use the first account for simplicity 
         ACAccount *twitterAccount = [twitterAccounts objectAtIndex: 0];
         
         NSLog(@"User granted access to his Twitter accounts");
         
         // Twitter API endpoint to update status
         NSURL *url = [NSURL URLWithString: @"http://api.twitter.com/1/statuses/update.json"];
         
         // Build the parameters for the Twitter request
         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
         
         [params setObject: message forKey: @"status"];
         
         //Build an authenticated request to the endpoint
         TWRequest *request = [[TWRequest alloc] initWithURL: url
                                                  parameters: params
                                               requestMethod: TWRequestMethodPOST]; // Status updates are made in POST
         
         // Attach the account object to this request
         [request setAccount: twitterAccount];
         
         [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
              if (!responseData) {
                // inspect the contents of error 
                NSLog(@"%@", error);
              } else {
                NSError *jsonError;
                NSArray *timeline = [NSJSONSerialization JSONObjectWithData: responseData 
                                                                    options: NSJSONReadingMutableLeaves 
                                                                      error: &jsonError];            
                if (timeline) {                          
                  // at this point, we have an object that we can parse
                  NSLog(@"%@", timeline);
                } else { 
                  // inspect the contents of jsonError
                  NSLog(@"%@", jsonError);
                }
              }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  // perform an action that updates the UI...
                  [self completePostOperations];
              });
            }];
           
          } else {
            NSLog(@"No Twitter Account Found");
            [self completePostOperations];
          }
        } // if (granted) 
      }];
}

- (void)postUpdate:(NSString *)update
{
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: update, @"message",
                                                                                   @"name", @"name",
                                                                                   @" ", @"caption",
                                                                                   @"Shared with Smile2me for iPhone", @"description",
                                                                                   nil];
  [facebook requestWithGraphPath: @"me/feed"
                       andParams: params
                   andHttpMethod: @"POST"
                     andDelegate: self];  
}

/**
 * This function access the sharedStopSpinnerIndicator to know if the spinner has to be stopped or not
 */
- (void)completePostOperations
{
  if (sharedStopSpinnerIndicator <= 1) {
    [postTextView setText: @""];
    
    [_postSendingProgressSpinner stopAnimating];
    [_postSendingProgressSpinner removeFromSuperview];
    
    UIImageView *sentOkView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 66, 66)];
    sentOkView.image = [UIImage imageNamed: @"Success"];
    sentOkView.center = CGPointMake(_spinnerBackground.bounds.size.width / 2, _spinnerBackground.bounds.size.height / 2);
    [_spinnerBackground addSubview: sentOkView];
    [sentOkView release];

    [UIView animateWithDuration: 1.0
                     animations: ^{ 
                       _spinnerBackground.alpha = 0.0; 
                     }
                     completion: ^(BOOL finished) { 
                       [_spinnerBackground removeFromSuperview]; 
                     }];
  } else {
    sharedStopSpinnerIndicator--;
  }
}


//
// FBSessionDelegate
//
- (void)fbDidLogin 
{
  [defaults setObject: [facebook accessToken] forKey: @"FBAccessTokenKey"];
  [defaults setObject: [facebook expirationDate] forKey: @"FBExpirationDateKey"];
  [defaults synchronize];
  
  NSLog(@"fbDidLogin");
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
  NSLog(@"fbDidNotLogin");  
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString *)accessToken
               expiresAt:(NSDate *)expiresAt
{  
  [defaults setObject: accessToken forKey: @"FBAccessTokenKey"];
  [defaults setObject: expiresAt forKey: @"FBExpirationDateKey"];
  [defaults synchronize];
  
  NSLog(@"fbDidExtendToken");  
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
  if ([defaults objectForKey: @"FBAccessTokenKey"]) {
    [defaults removeObjectForKey: @"FBAccessTokenKey"];
    [defaults removeObjectForKey: @"FBExpirationDateKey"];
    [defaults synchronize];
  }
  
  NSLog(@"fbDidLogout");
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
  NSLog(@"fbSessionInvalidated");
  
  [self completePostOperations];
}


//
// FBRequestDelegate
//
- (void)requestLoading:(FBRequest *)request
{
  NSLog(@"requestLoading");
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
  NSLog(@"didReceiveResponse");
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{  
  NSLog(@"didFailWithError %@", error);
  
  [self completePostOperations];

  postfb = NO;
  
  if ([facebook isSessionValid]) {
    [facebook logout];
  }

  [facebookSwitch setOn: NO animated: YES];

  [defaults setObject: [NSNumber numberWithBool: postfb] forKey: @"postFacebook"];
  [defaults synchronize];
  
  if ([postTextView isFirstResponder]) {
    [postTextView resignFirstResponder];
    settingsButton.enabled = NO;
  } 
  
  UIAlertView *av = [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Attention", @"") 
                                                message: NSLocalizedString(@"Your Facebook account rejected this post. Please try again later.", @"") 
                                               delegate: self 
                                      cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil] autorelease];
  [av show];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
  NSLog(@"didLoad");
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{    
  NSLog(@"didLoadRawResponse");
  
  [self completePostOperations];
}

@end



