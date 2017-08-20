//
//  SchoolRequestsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/24/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolRequestsViewController.h"
#import "UIViewController+Utilities.h"
#import "SchoolRequestCell.h"
#import "InviteViewController.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SchoolRequestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie
{
    self = [super initWithNibName:@"SchoolRequestsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.selectedUsersArray = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/network_requests.json",BaseURLString ];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _invitesArray  = (NSMutableArray *)JSON;
        [self updateInviteCount];
        [_tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Font
    _invitesRemainingLabel.textAlignment = NSTextAlignmentCenter;
    _invitesRemainingLabel.textColor = [UIColor whiteColor];
    _invitesRemainingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [(InviteViewController *)self.presentingViewController updateInviteCount];
    }];
}

- (IBAction)invite:(id)sender {
    //NSMutableData *postBody = (NSMutableData *)[NSKeyedArchiver archivedDataWithRootObject:_selectedUsersArray];
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

    NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/approve_requests",BaseURLString];
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
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Your invitations have been sent."
                                  message:@"Your friends can now join the network successfully."
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
            [alert show];
            [self refresh];
            [self updateInviteCount];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)updateInviteCount
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/me/invite_count.json",BaseURLString ];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *inviteCount = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([inviteCount isEqual:@"0"]) {
            _inviteButton = nil;
        }
        _invitesRemainingLabel.text = [NSString stringWithFormat:@"Invites Remaining: %@", inviteCount];
        _invitesRemainingLabel.textAlignment = NSTextAlignmentCenter;
        _inviteCount = (int)[inviteCount intValue];
        _inviteTextCount = _inviteCount;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)setInviteCount:(int)count
{
    _invitesRemainingLabel.text = [NSString stringWithFormat:@"Invites Remaining: %d", count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_invitesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolRequestCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SchoolRequestCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.userID = [NSString stringWithFormat:@"%@",[[_invitesArray objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.emailLabel.text = [[_invitesArray objectAtIndex:indexPath.row] objectForKey:@"user_email"];
    cell.schoolLabel.text = [[_invitesArray objectAtIndex:indexPath.row] objectForKey:@"school"];
        
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolRequestCell *cell = (SchoolRequestCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([_selectedUsersArray containsObject:cell.userID]) {
        [_selectedUsersArray removeObject:cell.userID];
        
        _inviteTextCount = _inviteTextCount+1;
        [self setInviteCount:_inviteTextCount];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.backgroundColor = [UIColor whiteColor];
        //cell.emailLabel.textColor = [UIColor blackColor];
        //cell.schoolLabel.textColor = [UIColor darkGrayColor];
    }
    else if(![_selectedUsersArray containsObject:cell.userID] && [_selectedUsersArray count] <= _inviteCount && _inviteTextCount > 0){
        [_selectedUsersArray addObject:cell.userID];
        
        _inviteTextCount = _inviteTextCount-1;
        [self setInviteCount:_inviteTextCount];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //cell.backgroundColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
        //cell.emailLabel.textColor = [UIColor whiteColor];
        //cell.schoolLabel.textColor = [UIColor lightGrayColor];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
