//
//  GroupInviteViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupInviteViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+Utilities.h"
#import "InviteCell.h"

#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID{
    self = [super initWithNibName:@"GroupInviteViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupID = groupID;
        self.selectedUsersArray = [NSMutableArray array];
    }
    return self;
}

- (IBAction)inviteUsers:(id)sender {
    if([_selectedUsersArray count] > 0) {
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"{"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\"user_ids\": ["] dataUsingEncoding:NSUTF8StringEncoding]];
        for(int x = 0; x < [_selectedUsersArray count]; x++) {
            if(x != [_selectedUsersArray count]-1) {
                [postBody appendData:[[NSString stringWithFormat:@"%@,", [_selectedUsersArray objectAtIndex:x]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else {
                [postBody appendData:[[NSString stringWithFormat:@"%@", [_selectedUsersArray objectAtIndex:x]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [postBody appendData:[[NSString stringWithFormat:@"]}"] dataUsingEncoding:NSUTF8StringEncoding]];
     
        NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/invite_users", BaseURLString, _groupID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset=utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postBody];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Your invitations have been sent."
                                      message:@"When your friends confirm the requests they will automatically join your group."
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
                [alert show];
            }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog([NSString stringWithFormat:@"%@",error]);
             [self alertServerError];
         }];
        [operation start];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No users are selected."
                              message:@"You do not have any users selected to invite."
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/groups/%@/possible_users_to_invite.json", BaseURLString, _groupID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_usersToInviteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.userID = [NSString stringWithFormat:@"%@",[[_usersToInviteArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    if([[NSString stringWithFormat:@"%@",[[_usersToInviteArray objectAtIndex:indexPath.row] objectForKey:@"is_available"]] isEqual:@"1"]) {
        cell.isAvailable = YES;
    }
    else {
        cell.isAvailable = NO;
        cell.imageView.alpha = .3;
        cell.nameLabel.alpha = .3;
    }
    cell.nameLabel.text = [[_usersToInviteArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[[_usersToInviteArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteCell *cell = (InviteCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.isAvailable == YES) {
        if([_selectedUsersArray containsObject:cell.userID]) {
            [_selectedUsersArray removeObject:cell.userID];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        else if(![_selectedUsersArray containsObject:cell.userID]){
            [_selectedUsersArray addObject:cell.userID];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


// HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *usersInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [usersInfo dataUsingEncoding:NSUTF8StringEncoding];
    _usersToInviteArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
}


@end
