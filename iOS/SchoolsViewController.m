//
//  SchoolsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolsViewController.h"
#import "UIViewController+Utilities.h"
#import "SchoolCell.h"
#import "SchoolViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SchoolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolsArray:(NSArray *)schoolsArray{
    self = [super initWithNibName:@"SchoolsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.schoolsArray = schoolsArray;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID
{
    self = [super initWithNibName:@"SchoolsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"Schools";
        self.schoolsArray = [NSArray array];
        self.sessionCookie = cookie;
        self.userID = userID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)aniamted
{
    if(_userID != nil) {
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/users/%@/schools.json", BaseURLString,_userID ] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else {
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/me/schools.json",BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
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
    NSString *responseInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [responseInfo dataUsingEncoding:NSUTF8StringEncoding];
    _schoolsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
}


// Table Delegate
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
    SchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SchoolCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.schoolHandle = [[_schoolsArray objectAtIndex:indexPath.row] objectForKey:@"handle"];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_schoolsArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.schoolImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"schoolAvatar.png"]];

    cell.schoolNameLabel.text = [[_schoolsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.schoolStatusLabel.text = [NSString stringWithFormat:@"Status: %@", [[_schoolsArray objectAtIndex:indexPath.row] objectForKey:@"membership_status"]];
    
    // Set default border radius.
    CALayer * layer = [cell.schoolImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolCell *cell = (SchoolCell *)[tableView cellForRowAtIndexPath:indexPath];
    SchoolViewController *schoolViewController = [[SchoolViewController alloc] initWithSessionCookie:_sessionCookie schoolHandle:cell.schoolHandle];
    [self.navigationController pushViewController:schoolViewController animated:YES];
}

@end
