//
//  GroupsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupsViewController.h"
#import "UIViewController+Utilities.h"
#import "GroupCell.h"
#import "UIViewController+Utilities.h"
#import "GroupViewController.h"
#import "GroupCreateViewController.h"
#import "NiteSiteButton.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupsArray:(NSArray *)groupsArray
{
    self = [super initWithNibName:@"GroupsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        if(groupsArray != nil) {
        self.groupsArray = groupsArray;
        }
        else {
            self.groupsArray = [NSArray array];
        }
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID
{
    self = [super initWithNibName:@"GroupsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"Groups";
        self.groupsArray = [NSArray array];
        self.sessionCookie = cookie;
        self.userID = userID;
        self.ownerClass = @"User";
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID
{
    self = [super initWithNibName:@"GroupsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"School Groups";
        self.groupsArray = [NSArray array];
        self.sessionCookie = cookie;
        self.schoolID = schoolID;
        self.ownerClass = @"School";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _toolBar.hidden = YES;
    [_createGroupButton setStyle:@"greenStyle"];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([_ownerClass isEqual:@"User"] && _userID != nil) {
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/users/%@/groups.json", BaseURLString,_userID ] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else if([_ownerClass isEqual:@"School"]) {
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/schools/%@/groups.json",BaseURLString, _schoolID ] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else {
        self.title = @"My Groups";
        _toolBar.hidden = NO;
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/me/groups.json",BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
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
    _groupsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
}

- (void)updateOwnGroups
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/groups/list.json",BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    _toolBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.groupID = [[_groupsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_groupsArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.groupImageView setImageWithURL:imageURL];
    
    cell.groupNameLabel.text = [[_groupsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.groupTypeLabel.text = [[_groupsArray objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    // Set default border radius.
    CALayer * layer = [cell.groupImageView layer];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GroupCell *cell = (GroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@", cell.groupID]];
    [self.navigationController pushViewController:groupViewController animated:YES];
}


- (IBAction)loadCreateGroup:(id)sender {
    GroupCreateViewController *groupCreateViewController = [[GroupCreateViewController alloc] initWithSessionCookie:_sessionCookie];
    [self presentViewController:groupCreateViewController animated:YES completion:nil];
}
@end
