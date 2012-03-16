//
//  AboutViewController.m
//  Post Office
//
//  Created by Andrea Gelati on 10/02/12.
//  Copyright (c) 2012 Command Guru. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize backButtonItem = _backButtonItem;

@synthesize versionLabel;
@synthesize nameAppLabel;
@synthesize aboutTableView;

@synthesize keys;
@synthesize sections;
@synthesize index;


#pragma mark - View Life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadDataForTableView 
{
    self.sections = [NSArray arrayWithObjects:@"Command Guru",@"iOS Developers & Graphics", nil];
	
    NSArray *companyLinks = [NSArray arrayWithObjects:@"Web Site", @"Twitter", @"Facebook" ,nil];
	NSArray *developers= [NSArray arrayWithObjects:   
                        @"Andrea Gelati", 
                        @"Enrico Sersale", 
                        @"Christian Zanin",
                        @"Gabriele Contilli",
                        @"Marco Palumbo",
                        @"Marco Temperilli",
                        @"Riccardo Soffritti", 
                        @"Giovanni Lodi",
                        @"Giovanni Maggini",
                        nil];
	NSArray *values = [NSArray arrayWithObjects:companyLinks, developers, nil];
	keys = [[NSDictionary alloc] initWithObjects:values forKeys: sections];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self loadDataForTableView];
}

- (void)viewWillAppear:(BOOL)animated 
{
 // UINavigationBar *bar = self.navigationController.navigationBar;

//  self.navigationController.navigationBarHidden = NO;  

  [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"TopBarAbout.png"] 
                                 forBarMetrics: UIBarMetricsDefault];
  
//  _backButtonItem = [[UIBarButtonItem alloc] init];
//  
  UIImage *backImageNormal = [UIImage imageNamed: @"BackBtnOff.png"];
  UIImage *backImageHighlighted = [UIImage imageNamed: @"BackBtnOn.png"];
//  
//   
//  backButton = [UIButton buttonWithType: UIButtonTypeCustom];
//  [backButton setFrame: CGRectMake(0, 0, backImageNormal.size.width, backImageNormal.size.height)];
//  [backButton setImage: backImageNormal forState: UIControlStateNormal];
//  [backButton setImage: backImageHighlighted forState: UIControlStateHighlighted];
//  [backButton addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
//  
//  UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(17, 0, backButton.bounds.size.width, backButton.bounds.size.height)];
//
//  label.text = NSLocalizedString(@"Back", @"");
//  label.backgroundColor = [UIColor clearColor];
//  label.textColor = [UIColor whiteColor];
//  label.font = [UIFont boldSystemFontOfSize: 12];
//  label.shadowColor = [UIColor grayColor];
//  
//  [backButton addSubview: label];
//  [label release];
//  
//  backButton.enabled = YES;
//  
//  [_backButtonItem setCustomView: backButton];
//  
////  [[self.navigationController.navigationBar topItem] setLeftBarButtonItem: _backButtonItem];
//  
//  [self.aboutTableView deselectRowAtIndexPath: [self.aboutTableView indexPathForSelectedRow] animated: animated];
//  
//  UIColor *titleColor = [UIColor blackColor];
//  NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:titleColor, UITextAttributeTextColor, nil];
//  [self.navigationController.navigationBar setTitleTextAttributes: attributes];
//  
//  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  
  UIButton * testButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [testButton setFrame:CGRectMake(0, 0, 58, 38)];
  [testButton setTitle:@" Back" forState:UIControlStateNormal];
  [[testButton titleLabel] setFont:[UIFont boldSystemFontOfSize: 12]];
  [[testButton titleLabel] setShadowColor:[UIColor grayColor]];
  [testButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
  [testButton setBackgroundImage:backImageHighlighted forState:UIControlStateNormal];
  [testButton setBackgroundImage:backImageNormal forState:UIControlStateHighlighted];
  
  UIBarButtonItem * test = [[UIBarButtonItem alloc]initWithCustomView:testButton];
  [[self navigationItem] setLeftBarButtonItem:test];
  
//  [[[[[self navigationController]navigationBar]topItem] backBarButtonItem] setBackButtonBackgroundImage:backImageNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//  [[[[[self navigationController]navigationBar]topItem] backBarButtonItem] setBackButtonBackgroundImage:backImageHighlighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{  
  [[[[self navigationController]navigationBar]topItem] setHidesBackButton:YES];

}

- (void)viewDidUnload
{
    [aboutTableView release];
    aboutTableView = nil;
    [nameAppLabel release];
    nameAppLabel = nil;
    [versionLabel release];
    versionLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack:(id)sender
{
  [self.navigationController popViewControllerAnimated: YES];
}

# pragma ===========================================================================      
# pragma ===========================================================================      
# pragma ===========================================================================
#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[keys valueForKey:[sections objectAtIndex:section]]count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
  
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
	self.index = [sections objectAtIndex:indexPath.section];
	cell.textLabel.text = [[keys valueForKey:self.index] objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if (indexPath.section == 0) 
    {
		switch (indexPath.row) {
			case 0:
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.commandguru.com"]];
				break;
			case 1:
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/#!/CommandGuru"]];
				break;
			case 2:
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Command-Guru/165781693932?sk=app_4949752878"]];
				break;	
			default:
                break;
        }
	}

	
    if (indexPath.section == 1) 
    {
		switch (indexPath.row) {
                /*
                @"Andrea Gelati", 
                @"Enrico Sersale", 
                @"Christian Zanin",
                @"Gabriele Contilli",
                @"Marco Palumbo",
                @"Marco Temperilli",
                @"Riccardo Soffritti", 
                @"Giovanni Lodi",
                @"Giovanni Maggini",
                */
                
			case 0:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"https://twitter.com/andreagelati"]];
				break;
			case 1:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"http://www.facebook.com/enrico.sersale"]];
				break;
			case 2:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"https://twitter.com/#!/christian_zanin"]];
				break;	
			case 3:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"https://twitter.com/#!/gcontilli"]];
				break;	
      case 4:
			//	[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"http://www.google.com"]];
				break;
			case 5:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"http://www.facebook.com/marco.maik"]];
				break;
			case 6:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"http://www.facebook.com/Riccardo.Soffritti"]];
				break;
      case 7:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"http://www.facebook.com/profile.php?id=1352904240"]];
				break;
			case 8:
				[[UIApplication sharedApplication]openURL: [NSURL URLWithString: @"https://twitter.com/#!/maggix"]];
				break;
			default:
        break;
        }
	}

    [self.aboutTableView deselectRowAtIndexPath:[self.aboutTableView indexPathForSelectedRow] animated:NO];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
  if (section == 0) {
    return 44;
  }
  
  return 34;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];

    //headerView setBackgroundColor:[UIColor whiteColor]];
    CGFloat y = (section == 0) ? 18.0 : 8;
  
    UILabel *label = [[[UILabel alloc] initWithFrame: CGRectMake(10, y, tableView.bounds.size.width - 10, 18)] autorelease];
    
    label.font = [UIFont boldSystemFontOfSize: 18];
  
    label.text = [self.sections objectAtIndex: section];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
  
    [headerView addSubview: label];

    return headerView;
}



# pragma ===========================================================================      
# pragma ===========================================================================      
# pragma ===========================================================================
#pragma mark - Dealloc

- (void)dealloc {
    [aboutTableView release];
    [nameAppLabel release];
    [versionLabel release];
    [super dealloc];
}
@end
