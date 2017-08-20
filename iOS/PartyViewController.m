//
//  PartyViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PartyViewController.h"
#import "UIViewController+Utilities.h"
#import "UsersViewController.h"
#import "GroupViewController.h"
#import "PartyInviteViewController.h"
#import "PartySettingsViewController.h"
#import "NiteSiteButton.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation PartyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie partyID:(NSString *)partyID
{
    self = [super initWithNibName:@"PartyViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.partyID = partyID;
        self.detailView.hidden = YES;
        self.toolBar.hidden = YES;
    }
    return self;
}

- (void)initializeParty
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 0;
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/parties/%@.json", BaseURLString,_partyID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Party";
    self.detailView.hidden = YES;
    self.toolBar.hidden = YES;
    _scrollView.scrollEnabled = NO;
    [_attendingUsersButton setStyle:@"whiteStyle"];
    [_hostGroupButton setStyle:@"whiteStyle"];
    
    // Font
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"";
    
    _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _locationLabel.textColor = [UIColor lightGrayColor];
    _locationLabel.text = @"";
    
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.text = @"";
    
    _additionalDetailsLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _additionalDetailsLabel.textColor = [UIColor lightGrayColor];
    _additionalDetailsLabel.text = @"";
    
    _attendingUsersLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _attendingUsersLabel.textAlignment = NSTextAlignmentCenter;
    _attendingUsersLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _hostGroupLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _hostGroupLabel.textAlignment = NSTextAlignmentCenter;
    _hostGroupLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    // Set default border radius.
    CALayer * layer = [_partyImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_hostGroupImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeParty];
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
    [self alertServerError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(_HTTPTag == 0) {
        NSString *partyInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        NSData *data = [partyInfo dataUsingEncoding:NSUTF8StringEncoding];
        _partyDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self updateParty];
    }
}

- (void)updateParty
{
    [_partyImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_partyDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];
    _nameLabel.text = [_partyDict objectForKey:@"name"];
    _locationLabel.text = [_partyDict objectForKey:@"address"];
    _relation = [_partyDict objectForKey:@"relation"];
    _timeLabel.text = [_partyDict objectForKey:@"time_presented"];
    [self alterActionButton];
    
    NSMutableDictionary *sampleObject;
    // Attending Users
    NSString *attendingUsersCount = [NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"attending_users_count"]];
    _attendingUsersLabel.text = attendingUsersCount;
    NSDictionary *attendingUsersSampleDict = [_partyDict objectForKey:@"attending_users_sample"];
    NSArray *membersSampleArray = [_partyDict objectForKey:@"attending_users_sample"];
    if([attendingUsersCount isEqual: @"1"]) {
        [_attendingUsersButton setTitle: @"Attending User" forState:UIControlStateNormal];
    }
    if([attendingUsersSampleDict count] > 0) {
        sampleObject = membersSampleArray[0];
        [_attendingUserImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([attendingUsersSampleDict count] > 1) {
        sampleObject = membersSampleArray[1];
        [_attendingUserImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([attendingUsersSampleDict count] > 2) {
        sampleObject = membersSampleArray[2];
        [_attendingUserImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([attendingUsersSampleDict count] > 3) {
        sampleObject = membersSampleArray[3];
        [_attendingUserImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([attendingUsersSampleDict count] > 4) {
        sampleObject = membersSampleArray[4];
        [_attendingUserImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([attendingUsersSampleDict count] > 5) {
        sampleObject = membersSampleArray[5];
        [_attendingUserImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // If the party is over
    if([[NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"is_over"]] isEqual:@"1"]) {
        _actionButton.alpha = .5;
        [_actionButton setTitle:@"This party is over." forState:UIControlStateNormal];
    }
    
    // Admin stuff
    if([[NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"is_group_admin"]] isEqual:@"1"] && [[NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"is_over"]] isEqual:@"0"]) {
        _toolBar.hidden = NO;
    }
    
    // Host Group
    _hostGroupLabel.text = [_partyDict objectForKey:@"group_name"];
    
    // Additional Details
    if(![[_partyDict objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        _detailView.hidden = NO;
        _additionalDetailsLabel.text = [NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"description"]];
    }
}

- (IBAction)loadAttendingUsers:(id)sender {
    UsersViewController *usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie partyID:_partyID];
    [self.navigationController pushViewController:usersViewController animated:YES];
}

- (IBAction)loadHostGroup:(id)sender {
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"group_id"]]]];
    [self.navigationController pushViewController:groupViewController animated:YES];
}

- (void)alterActionButton
{
    if([[NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"is_over"]] isEqual:@"0"]) {
        // Action button
        if([_relation isEqualToString:@"attending"]) {
            [_actionButton setTitle: @"Attending" forState:UIControlStateNormal];
            [_actionButton setStyle:@"blueStyle"];
        }
        else if([_relation isEqualToString:@"not_attending"]) {
            [_actionButton setTitle: @"Attend" forState:UIControlStateNormal];
            [_actionButton setStyle:@"greyStyle"];
        }
    }
}

- (IBAction)loadAction:(id)sender
{
    if([_relation isEqual:@"not_attending"] && [[NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"is_over"]] isEqual:@"0"])
    {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/parties/%@/attend",BaseURLString, _partyID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                _relation = @"attending";
                [self initializeParty];
                [self alterActionButton];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
        }];
        [operation start];
    }
}
- (IBAction)loadInvite:(id)sender {
    PartyInviteViewController *partyInviteViewController = [[PartyInviteViewController alloc] initWithSessionCookie:_sessionCookie partyID:_partyID];
    [self presentViewController:partyInviteViewController animated:YES completion:nil];
}

- (IBAction)loadSettings:(id)sender {
    PartySettingsViewController *partySettingsViewController = [[PartySettingsViewController alloc] initWithSessionCookie:_sessionCookie partyDict:_partyDict];
    [self presentViewController:partySettingsViewController animated:YES completion:nil];
}
@end
