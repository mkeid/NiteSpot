//
//  SearchViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+Utilities.h"
#import "UserViewController.h"
#import "UserCell.h"
#import "GroupViewController.h"
#import "GroupCell.h"

// Frameworks
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultsArray = [NSArray array];
    }
    return self;
}

- (IBAction)search:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    switch([_searchBar selectedScopeButtonIndex]) {
        case 0:
            _searchClass = @"User";
            [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/search/users.json?query=%@", BaseURLString, _searchBar.text] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
            break;
        case 1:
            _searchClass = @"Group";
            [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/search/groups.json?query=%@", BaseURLString, _searchBar.text] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
            break;
    }
}

- (IBAction)resignKeyboard:(id)sender {
    [_searchBar resignFirstResponder];
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
    [_searchBar resignFirstResponder];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *searchInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [searchInfo dataUsingEncoding:NSUTF8StringEncoding];
    _resultsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
    [_searchBar resignFirstResponder];
}

- (id)initWithSessionCookie:(NSArray *)cookie {
    self = [super initWithNibName:@"SearchViewController" bundle:nil];
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
    self.title = @"Search";
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchBar selectedScopeButtonIndex] == 0) {
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.userID = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [cell.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
        
        cell.nameLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.schoolLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"];
        
        // Set default border radius.
        CALayer * layer = [cell.userImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        return cell;
    }
    else {
        
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.groupID = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [cell.groupImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];

        cell.groupNameLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        cell.groupTypeLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"type"];
        
        // Set default border radius.
        CALayer * layer = [cell.groupImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        return cell;
    }
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchBar selectedScopeButtonIndex] == 0) {
        return 50;
    }
    else {
        return 75;
    }
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([_searchClass isEqual:@"User"]) {
        UserCell *cell = (UserCell *)[tableView cellForRowAtIndexPath:indexPath];
        UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:cell.userID];
        [self.navigationController pushViewController:userViewController animated:YES];
    }
    else if([_searchClass isEqual:@"Group"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
         
         GroupCell *cell = (GroupCell *)[tableView cellForRowAtIndexPath:indexPath];
         GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@", cell.groupID]];
         [self.navigationController pushViewController:groupViewController animated:YES];
    }
}

// Search Delegate
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [self search:nil];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}


@end
