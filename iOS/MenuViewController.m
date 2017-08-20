//
//  MenuViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "AppDelegate.h"
#import "NiteSiteNavigationController.h"
#import "MenuViewController.h"
#import "UIViewController+Utilities.h"
#import "UserViewController.h"
#import "SettingsViewController.h"
#import "SearchViewController.h"
#import "FeedViewController.h"
#import "PlacesViewController.h"
#import "PartiesViewController.h"
#import "CabsViewController.h"
#import "GroupsViewController.h"
#import "SchoolsViewController.h"
#import "InviteViewController.h"
#import "MenuCell.h"
#import "WelcomeViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie {
    self = [super initWithNibName:@"MenuViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView setScrollEnabled:NO];
    // Set default border radius.
    CALayer * layer = [_imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.shadowOpacity = 1.0f;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeZero;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:_imageView.bounds].CGPath;
    layer.shouldRasterize = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateMenu];
}

- (void)updateMenu
{
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/me.json", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (IBAction)closeMenu:(id)sender {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRootController:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Oops!"
                               message:@"There was a server error."
                               delegate:nil
                               cancelButtonTitle:@"Ok."
                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSDictionary *meDict = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:nil];
    [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[meDict valueForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    [_nameButton setTitle:[NSString stringWithFormat:@"%@",[meDict valueForKey:@"name"]] forState:UIControlStateNormal];
}
//

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    switch(indexPath.row)
    {
        case 0:
            [cell.cellLabel setText:@"Feed"];
            cell.cellImage.image = [UIImage imageNamed:@"feed.png"];
            break;
        case 1:
            [cell.cellLabel setText:@"Places"];
            cell.cellImage.image = [UIImage imageNamed:@"places.png"];
            break;
        case 2:
            [cell.cellLabel setText:@"Parties"];
            cell.cellImage.image = [UIImage imageNamed:@"parties.png"];
            break;
        case 3:
            [cell.cellLabel setText:@"Cabs"];
            cell.cellImage.image = [UIImage imageNamed:@"cabs.png"];
            break;
        case 4:
            [cell.cellLabel setText:@"Groups"];
            cell.cellImage.image = [UIImage imageNamed:@"groups.png"];
            break;
        case 5:
            [cell.cellLabel setText:@"Schools"];
            cell.cellImage.image = [UIImage imageNamed:@"schools.png"];
            break;
        case 6:
            [cell.cellLabel setText:@"Invite"];
            cell.cellImage.image = [UIImage imageNamed:@"invite.png"];
            break;
    }
    cell.backgroundColor = [UIColor whiteColor];
    CALayer * layer = [cell.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return ([UIScreen mainScreen].applicationFrame.size.height - 120) / 7;
    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0:
            [self loadFeed];
            break;
        case 1:
            [self loadPlaces];
            break;
        case 2:
            [self loadParties];
            break;
        case 3:
            [self loadCabs];
            break;
        case 4:
            [self loadGroups];
            break;
        case 5:
            [self loadSchools];
            break;
        case 6:
            [self loadInvite];
            break;
        default:
            [self loadFeed];
            break;
    }
}

- (IBAction)loadUser:(id)sender {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:userViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)loadSettings:(id)sender {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithSessionCookie:_sessionCookie];
    settingsViewController.meDict = _meDict;
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:settingsViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)loadSearch:(id)sender {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:searchViewController];
    [menuController setRootController:navController animated:YES];
}

- (void)loadFeed {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    FeedViewController *feedViewController = [[FeedViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:feedViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadPlaces {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    PlacesViewController *placesViewController = [[PlacesViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:placesViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadParties {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    PartiesViewController *partiesViewController = [[PartiesViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:partiesViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadCabs {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    CabsViewController *cabsViewController = [[CabsViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:cabsViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadGroups {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    GroupsViewController *groupsViewController = [[GroupsViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:groupsViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadSchools {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    SchoolsViewController *schoolsViewController = [[SchoolsViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:schoolsViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadInvite {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    InviteViewController *inviteViewController = [[InviteViewController alloc] initWithSessionCookie:_sessionCookie];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:inviteViewController];
    [menuController setRootController:navController animated:YES];
}

@end
