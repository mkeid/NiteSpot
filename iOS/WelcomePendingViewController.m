//
//  WelcomePendingViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/12/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "WelcomePendingViewController.h"
#import "AboutViewController.h"
#import "TutorialViewController.h"
#import "UIViewController+Utilities.h"
#import "WelcomeViewController.h"
#import "PendingNetworkCell.h"
#import "SSKeychain.h"

#import "PlacesViewController.h"
#import "MenuViewController.h"
#import "AlertsViewController.h"
#import "NiteSiteNavigationController.h"
#import "DDMenucontroller.h"
#import "AppDelegate.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation WelcomePendingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)signOut:(id)sender {
    // Retrieve stored account & password from keychain.
    NSArray *accountsArray = [SSKeychain accountsForService:@"NiteSite"];
    NSDictionary *accountDict = (NSDictionary *)[accountsArray objectAtIndex:0];
    NSString *account = (NSString *)[accountDict objectForKey:@"acct"];
    [SSKeychain deletePasswordForService:@"NiteSite" account:account];
    
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc]
                                                    initWithNibName:@"WelcomeViewController"
                                                    bundle:[NSBundle mainBundle]];
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
    DDMenuController *ddMenuViewController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    ddMenuViewController.leftViewController = aboutViewController;
    ddMenuViewController.rightViewController = tutorialViewController;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    navController.navigationBar.hidden = YES;
    [ddMenuViewController setRootController:navController animated:YES];
}

- (IBAction)updateRequestsAction:(id)sender {
    [self updateRequests];
}

- (id)initWithSessionCookie:(NSArray *)cookie
{
    self = [super initWithNibName:@"WelcomePendingViewController" bundle:nil];
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
    self.navigationController.navigationBar.hidden = YES;
    [_refreshButton setStyle:@"greyStyle"];
    [_signOutButton setStyle:@"greyStyle"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self updateRequests];
}
- (void)updateRequests
{
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/me/requested_schools.json", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_schoolsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PendingNetworkCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingNetworkCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [[_schoolsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[[_schoolsArray objectAtIndex:indexPath.row]objectForKey:@"avatar_location"]]]];
    if(cell.imageView.image == nil) {
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[[_schoolsArray objectAtIndex:indexPath.row]objectForKey:@"avatar_location"]]]]];
    }
    
    // Set default border radius.
    CALayer * layer = [cell.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    NSString *responseInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [responseInfo dataUsingEncoding:NSUTF8StringEncoding];
    _schoolsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([_schoolsArray count] > 0) {
        [_tableView reloadData];
    }
    else {
        PlacesViewController *placesViewController = [[PlacesViewController alloc] initWithSessionCookie:_sessionCookie];
        
        MenuViewController *menuViewController = [[MenuViewController alloc] initWithSessionCookie:_sessionCookie];
        
        AlertsViewController *alertsViewController = [[AlertsViewController alloc] initWithSessionCookie:_sessionCookie];
        
        
        DDMenuController *ddMenuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        ddMenuController.leftViewController = menuViewController;
        ddMenuController.rightViewController = alertsViewController;
        NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:placesViewController];
        [ddMenuController setRootController:navController animated:YES];
    }
}

@end
