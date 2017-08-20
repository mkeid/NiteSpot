//
//  GroupViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupViewController.h"
#import "UIViewController+Utilities.h"
#import "UsersViewController.h"
#import "GroupPartiesViewController.h"
#import "FeedViewController.h"
#import "GroupStatisticsViewController.h"
#import "GroupTopPartiersViewController.h"
#import "NiteSiteButton.h"

// Group Admin Controllers
#import "GroupRequestsViewController.h"
#import "GroupInviteViewController.h"
#import "GroupThrowPartyViewController.h"
#import "GroupSettingsViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID{
    self = [super initWithNibName:@"GroupViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupID = groupID;
    }
    return self;
}

- (void)initializeGroup
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 0;
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/groups/%@.json", BaseURLString,_groupID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
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
    if(_HTTPTag == 0) {
        NSString *groupInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        NSData *data = [groupInfo dataUsingEncoding:NSUTF8StringEncoding];
        _groupDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self updateGroup];
    }
}

- (void)setUpScroll
{
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,460);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Group";
    _toolBar.hidden = YES;
    [_membersButton setStyle:@"whiteStyle"];
    [_adminsButton setStyle:@"whiteStyle"];
    [_partiesButton setStyle:@"whiteStyle"];
    [_topPartiersButton setStyle:@"whiteStyle"];
    [_statisticsButton setStyle:@"whiteStyle"];
    [_shoutsButton setStyle:@"whiteStyle"];
    
    // Font
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"";
    
    _schoolLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _schoolLabel.textColor = [UIColor lightGrayColor];
    _schoolLabel.text = @"";
    
    _typeLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.text = @"";
    
    _memberCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _memberCountLabel.textAlignment = NSTextAlignmentCenter;
    _memberCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _adminCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _adminCountLabel.textAlignment = NSTextAlignmentCenter;
    _adminCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _partyCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _partyCountLabel.textAlignment = NSTextAlignmentCenter;
    _partyCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    // Set default border radius.
    CALayer * layer = [_groupImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_topPartiersImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_shoutsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_statisticsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeGroup];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self setUpScroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateGroup
{
    _relation = [_groupDict objectForKey:@"relation"];
    _groupPrivacy = (NSString *)[_groupDict objectForKey:@"privacy"];
    [_groupImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_groupDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];
    
    _nameLabel.text = [_groupDict objectForKey:@"name"];
    _schoolLabel.text = [_groupDict objectForKey:@"school"];
    _typeLabel.text = [_groupDict objectForKey:@"type"];
    if([_relation isEqual:@"is_admin"] || [_relation isEqual:@"is_only_admin"]) {
        [_toolBar setHidden:NO];
        [self setUpScroll];
    }
    else {
        [_toolBar setHidden:YES];
    }
    [self alterActionButton];
    
    
    NSMutableDictionary *sampleObject;
    // Members
    NSString *memberCount = [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"members_count"]];
    _memberCountLabel.text = memberCount;
    NSDictionary *membersSampleDict = [_groupDict objectForKey:@"sample_members"];
    NSArray *membersSampleArray = [_groupDict objectForKey:@"sample_members"];
    if([memberCount isEqual: @"1"]) {
        [_membersButton setTitle: @"Member" forState:UIControlStateNormal];
    }
    if([membersSampleDict count] > 0) {
        sampleObject = membersSampleArray[0];
       [_memberImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([membersSampleDict count] > 1) {
        sampleObject = membersSampleArray[1];
        [_memberImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([membersSampleDict count] > 2) {
        sampleObject = membersSampleArray[2];
        [_memberImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([membersSampleDict count] > 3) {
        sampleObject = membersSampleArray[3];
        [_memberImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([membersSampleDict count] > 4) {
        sampleObject = membersSampleArray[4];
        [_memberImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([membersSampleDict count] > 5) {
        sampleObject = membersSampleArray[5];
        [_memberImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Admins
    NSString *adminCount = [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"admins_count"]];
    _adminCountLabel.text = adminCount;
    NSDictionary *adminsSampleDict = [_groupDict objectForKey:@"sample_admins"];
    NSArray *adminsSampleArray = [_groupDict objectForKey:@"sample_admins"];
    if([adminCount isEqual: @"1"]) {
        [_adminsButton setTitle: @"Admin" forState:UIControlStateNormal];
    }
    if([adminsSampleDict count] > 0) {
        sampleObject = adminsSampleArray[0];
        [_adminImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([adminsSampleDict count] > 1) {
        sampleObject = adminsSampleArray[1];
        [_adminImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([adminsSampleDict count] > 2) {
        sampleObject = adminsSampleArray[2];
        [_adminImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([adminsSampleDict count] > 3) {
        sampleObject = adminsSampleArray[3];
        [_adminImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([adminsSampleDict count] > 4) {
        sampleObject = adminsSampleArray[4];
        [_adminImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([adminsSampleDict count] > 5) {
        sampleObject = adminsSampleArray[5];
        [_adminImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Parties
    NSString *partyCount = [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"parties_count"]];
    _partyCountLabel.text = partyCount;
    NSDictionary *partiesSampleDict = [_groupDict objectForKey:@"sample_parties"];
    NSArray *partiesSampleArray = [_groupDict objectForKey:@"sample_parties"];
    if([partyCount isEqual: @"1"]) {
        [_partiesButton setTitle: @"Party" forState:UIControlStateNormal];
    }
    if([partiesSampleDict count] > 0) {
        sampleObject = partiesSampleArray[0];
        [_partyImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([partiesSampleDict count] > 1) {
        sampleObject = partiesSampleArray[1];
        [_partyImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([partiesSampleDict count] > 2) {
        sampleObject = partiesSampleArray[2];
        [_partyImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([partiesSampleDict count] > 3) {
        sampleObject = partiesSampleArray[3];
        [_partyImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([partiesSampleDict count] > 4) {
        sampleObject = partiesSampleArray[4];
        [_partyImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([partiesSampleDict count] > 5) {
        sampleObject = partiesSampleArray[5];
        [_partyImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    if([_relation isEqual:@"is_admin"] || [_relation isEqual:@"is_only_admin"]) {
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(320,460);
        if(![[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"requests_count"]] isEqual: @"0"]) {
            [_requestsButton setTintColor:[UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1]];
        }
        else {
            [_requestsButton setTintColor:[UIColor lightGrayColor]];
        }
    }
    
    if([_relation isEqual:@"pending"] || ([_relation isEqual:@"not_in_group"] && [_groupPrivacy isEqual:@"private"])) {
        /*_membersButton.alpha = .5;
        _memberImage1.alpha = .5;
        _memberImage2.alpha = .5;
        _memberImage3.alpha = .5;
        _memberImage4.alpha = .5;
        _memberImage5.alpha = .5;
        _memberImage6.alpha = .5;
        _memberCountLabel.alpha = .5;
        
        _adminsButton.alpha = .5;
        _adminImage1.alpha = .5;
        _adminImage2.alpha = .5;
        _adminImage3.alpha = .5;
        _adminImage4.alpha = .5;
        _adminImage5.alpha = .5;
        _adminImage6.alpha = .5;
        _adminCountLabel.alpha = .5;
        
        _partiesButton.alpha = .5;
        _partyImage1.alpha = .5;
        _partyImage2.alpha = .5;
        _partyImage3.alpha = .5;
        _partyImage4.alpha = .5;
        _partyImage5.alpha = .5;
        _partyImage6.alpha = .5;
        _partyCountLabel.alpha = .5;
        
        _topPartiersButton.alpha = .5;
        _topPartiersImageView.alpha = .5;
        
        _shoutsButton.alpha = .5;
        _shoutsImageView.alpha = .5;
        
        _statisticsButton.alpha = .5;
        _statisticsImageView.alpha = .5;*/
    }
}

- (IBAction)loadMembers:(id)sender {
        UsersViewController *usersViewController;
        if([_relation isEqual:@"is_admin"] || [_relation isEqual:@"is_only_admin"]) {
            usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID isAdmin:YES usersType:@"Members"];
        }
        else {
            usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID isAdmin:NO usersType:@"Members"];
        }
        [self.navigationController pushViewController:usersViewController animated:YES];
}

- (IBAction)loadAdmins:(id)sender {
    UsersViewController *usersViewController;
    if([_relation isEqual:@"is_admin"] || [_relation isEqual:@"is_only_admin"]) {
        usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID isAdmin:YES usersType:@"Admins"];
    }
    else {
        usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID isAdmin:NO usersType:@"Admins"];
    }
    [self.navigationController pushViewController:usersViewController animated:YES];
}

- (IBAction)loadParties:(id)sender {
    GroupPartiesViewController *groupPartiesViewController = [[GroupPartiesViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self.navigationController pushViewController:groupPartiesViewController animated:YES];
}

- (IBAction)loadTopPartiers:(id)sender {    
    GroupTopPartiersViewController *groupTopPartiersViewController = [[GroupTopPartiersViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self.navigationController pushViewController:groupTopPartiersViewController animated:YES];
}

- (IBAction)loadStatistics:(id)sender {
    GroupStatisticsViewController *groupStatisticsViewController = [[GroupStatisticsViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self.navigationController pushViewController:groupStatisticsViewController animated:YES];
}

- (IBAction)loadShouts:(id)sender {
    FeedViewController *feedViewController = [[FeedViewController alloc] initWithSessionCookie:_sessionCookie profileClass:@"Group" profileID:_groupID];
    [self.navigationController pushViewController:feedViewController animated:YES];
}

- (void)alterActionButton
{
    // Action button
    if([_relation isEqualToString:@"is_member"]) {
        [_actionButton setTitle: @"Joined" forState:UIControlStateNormal];
        [_actionButton setStyle:@"blueStyle"];
    }
    else if([_relation isEqualToString:@"is_admin"]) {
        [_actionButton setTitle: @"Joined" forState:UIControlStateNormal];
        [_actionButton setStyle:@"blueStyle"];
    }
    else if([_relation isEqualToString:@"is_only_admin"]) {
        [_actionButton setTitle: @"Joined" forState:UIControlStateNormal];
        [_actionButton setStyle:@"blueStyle"];
    }
    else if([_relation isEqualToString:@"not_in_group"]) {
        if([_groupPrivacy isEqual:@"private"]) {
            [_actionButton setTitle: @"Ask To Join" forState:UIControlStateNormal];
            [_actionButton setStyle:@"greyStyle"];
        }
        else {
            [_actionButton setTitle: @"Join" forState:UIControlStateNormal];
            [_actionButton setStyle:@"greyStyle"];
        }
    }
    else if([_relation isEqualToString:@"pending"]) {
        [_actionButton setTitle: @"Pending Request" forState:UIControlStateNormal];
        [_actionButton setStyle:@"pendingStyle"];
    }
}
- (IBAction)loadAction:(id)sender
{
    if([_relation isEqual:@"is_member"])
    {
        [self askToLeaveGroup];
    }
    else if([_relation isEqual:@"is_admin"])
    {
        [self askToLeaveGroup];
    }
    else if([_relation isEqual:@"is_only_admin"])
    {
        [self askToDestroyGroup];
    }
    else if([_relation isEqual:@"not_in_group"])
    {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/join",BaseURLString,_groupID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                NSLog(_groupPrivacy);
                if([_groupPrivacy isEqual:@"private"]) {
                    _relation = @"pending";
                    [self initializeGroup];
                    [self alterActionButton];
                }
                else {
                    _relation = @"is_member";
                    [self initializeGroup];
                    [self alterActionButton];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
            NSLog([NSString stringWithFormat:@"%@",error]);
        }];
        [operation start];
    }
    else if([_relation isEqual:@"pending"])
    {
    }
    
}
- (void)groupLeave
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/leave",BaseURLString,_groupID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
            _relation = @"not_in_group";
            [self initializeGroup];
            [self alterActionButton];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}
- (void)groupDestroy
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/leave",BaseURLString,_groupID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}
- (void)askToLeaveGroup
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Group Leave" message:[NSString stringWithFormat:@"Are you sure you want to leave %@?", [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"name"]]] delegate: self cancelButtonTitle: @"No"  otherButtonTitles:@"Yes",nil];
    alert.tag = 0;
    [alert show];
}
- (void)askToDestroyGroup
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Group Leave" message:[NSString stringWithFormat:@"You are the only admin of this group. If you leave, the group will be deleted. Are you sure you want to leave %@?", [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"name"]]] delegate: self cancelButtonTitle: @"No"  otherButtonTitles:@"Yes",nil];
    alert.tag = 1;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex==1) {
            [self groupLeave];
        }
    }
    else if(alertView.tag==1)
    {
        if(buttonIndex==1) {
            [self groupDestroy];
        }
    }
}

- (IBAction)loadRequests:(id)sender {
    GroupRequestsViewController *groupRequestsViewController = [[GroupRequestsViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self presentViewController:groupRequestsViewController animated:YES completion:nil];
}

- (IBAction)loadInvite:(id)sender {
    GroupInviteViewController *groupInviteViewController = [[GroupInviteViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self presentViewController:groupInviteViewController animated:YES completion:nil];
}

- (IBAction)loadThrowParty:(id)sender {
    GroupThrowPartyViewController *groupThrowPartyViewController = [[GroupThrowPartyViewController alloc] initWithSessionCookie:_sessionCookie groupID:_groupID];
    [self presentViewController:groupThrowPartyViewController animated:YES completion:nil];
}

- (IBAction)loadSettings:(id)sender {
    GroupSettingsViewController *groupSettingsViewController = [[GroupSettingsViewController alloc] initWithSessionCookie:_sessionCookie groupDict:_groupDict];
    [self presentViewController:groupSettingsViewController animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}


@end