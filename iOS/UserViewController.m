//
//  UserViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UserViewController.h"
#import "UIViewController+Utilities.h"
#import "UsersViewController.h"
#import "FeedViewController.h"
#import "UserstatisticsViewController.h"
#import "GroupsViewController.h"
#import "SchoolsViewController.h"
#import "SettingsviewController.h"
#import "NiteSiteNavigationController.h"
#import "NiteSiteButton.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID{
    self = [super initWithNibName:@"UserViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.userID = userID;
    }
    return self;
}
- (void)initializeUser
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    if(_userID == nil) { 
        NSString *requestURLString = [NSString stringWithFormat:@"%@/me.json", BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _userDict  = (NSDictionary *)JSON;
            [self updateUser];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
    else {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@.json", BaseURLString, _userID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _userDict  = (NSDictionary *)JSON;
            [self updateUser];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"User";
    _scrollView.scrollEnabled = NO;
    [_followingButton setStyle:@"whiteStyle"];
    [_followersButton setStyle:@"whiteStyle"];
    [_groupsButton setStyle:@"whiteStyle"];
    [_schoolsButton setStyle:@"whiteStyle"];
    [_statisticsButton setStyle:@"whiteStyle"];
    [_shoutsButton setStyle:@"whiteStyle"];
    
    // Font
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.text = @"";
    
    _schoolLabel.textColor = [UIColor lightGrayColor];
    _schoolLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _schoolLabel.text = @"";
    
    _yearLabel.textColor = [UIColor lightGrayColor];
    _yearLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _yearLabel.text = @"";
    
    _followsYouLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    _followsYouLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _followsYouLabel.text = @"";
    
    _attendingLabel.textColor = [UIColor colorWithRed:.588 green:.8157 blue:.2863 alpha:1];
    _attendingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _attendingLabel.text = @"";
    
    _followersCountLabel.textAlignment = NSTextAlignmentCenter;
    _followersCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _followersCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _followingCountLabel.textAlignment = NSTextAlignmentCenter;
    _followingCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _followingCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _groupsCountLabel.textAlignment = NSTextAlignmentCenter;
    _groupsCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _groupsCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    // Set default border radius.
    CALayer * layer = [_userImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_schoolsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_shoutsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_statisticsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUser
{
    _userID = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"id"]];
    [_userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_userDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];

    NSString *genderSymbol;
    if([[_userDict objectForKey:@"gender" ] isEqual: @"male"]) {
        genderSymbol = @"♂";
    }
    else {
        genderSymbol = @"♀";
    }
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",[_userDict objectForKey:@"name"],genderSymbol];
    _schoolLabel.text = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"primary_school"]];
    _yearLabel.text = [[[[_userDict objectForKey:@"year"] substringToIndex:1] uppercaseString] stringByAppendingString:[[_userDict objectForKey:@"year"] substringFromIndex:1]];
    if([[NSString stringWithFormat:@"%@",[_userDict objectForKey:@"follows_you"]] isEqual:@"1"]) {
       _followsYouLabel.text = @"Follows You";
    }
    _attendingLabel.text = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"attending_place"]];
    
    _userRelation = [_userDict objectForKey:@"relation"];
    _userPrivacy = [_userDict objectForKey:@"privacy"];

    [self alterActionButton];
    
    _followersImage1.image = nil;
    _followersImage2.image = nil;
    _followersImage3.image = nil;
    _followersImage4.image = nil;
    _followersImage5.image = nil;
    _followersImage6.image = nil;
    
    NSMutableDictionary *sampleObject;
    // Following
    _followingCountLabel.text = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"following_count"]];
    NSDictionary *followingSampleDict = [_userDict objectForKey:@"following_sample"];
    NSArray *followingSampleArray = [_userDict objectForKey:@"following_sample"];
    if([followingSampleDict count] > 0) {
        sampleObject = followingSampleArray[0];
        [_followingImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followingSampleDict count] > 1) {
        sampleObject = followingSampleArray[1];
        [_followingImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followingSampleDict count] > 2) {
        sampleObject = followingSampleArray[2];
        [_followingImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followingSampleDict count] > 3) {
        sampleObject = followingSampleArray[3];
        [_followingImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followingSampleDict count] > 4) {
        sampleObject = followingSampleArray[4];
        [_followingImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followingSampleDict count] > 5) {
        sampleObject = followingSampleArray[5];
        [_followingImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Followers
    NSString *followersCount = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"follower_count"]];
    _followersCountLabel.text = followersCount;
    NSDictionary *followerSampleDict = [_userDict objectForKey:@"follower_sample"];
    NSArray *followerSampleArray = [_userDict objectForKey:@"follower_sample"];
    if([followersCount isEqual: @"1"]) {
        [_followersButton setTitle: @"Follower" forState:UIControlStateNormal];
    }
    else {
        [_followersButton setTitle: @"Followers" forState:UIControlStateNormal];
    }
    if([followerSampleDict count] > 0) {
        sampleObject = followerSampleArray[0];
        [_followersImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followerSampleDict count] > 1) {
        sampleObject = followerSampleArray[1];
        [_followersImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followerSampleDict count] > 2) {
        sampleObject = followerSampleArray[2];
        [_followersImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followerSampleDict count] > 3) {
        sampleObject = followerSampleArray[3];
        [_followersImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followerSampleDict count] > 4) {
        sampleObject = followerSampleArray[4];
        [_followersImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([followerSampleDict count] > 5) {
        sampleObject = followerSampleArray[5];
        [_followersImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    
    // Groups
    NSString *groupCount = [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"group_count"]];
    _groupsCountLabel.text = groupCount;
    NSDictionary *groupSampleDict = [_userDict objectForKey:@"group_sample"];
    NSArray *groupSampleArray = [_userDict objectForKey:@"group_sample"];
    if([groupCount isEqual:@"1"]) {
        [_groupsButton setTitle: @"Group" forState:UIControlStateNormal];
    }
    else {
        [_groupsButton setTitle: @"Groups" forState:UIControlStateNormal];
    }
    if([groupSampleDict count] > 0) {
        sampleObject = groupSampleArray[0];
        [_groupsImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([groupSampleDict count] > 1) {
        sampleObject = groupSampleArray[1];
        [_groupsImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([groupSampleDict count] > 2) {
        sampleObject = groupSampleArray[2];
        [_groupsImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([groupSampleDict count] > 3) {
        sampleObject = groupSampleArray[3];
        [_groupsImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([groupSampleDict count] > 4) {
        sampleObject = groupSampleArray[4];
        [_groupsImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([groupSampleDict count] > 5) {
        sampleObject = groupSampleArray[5];
        [_groupsImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    if([_userRelation isEqual:@"pending"] || ([_userRelation isEqual:@"not_following"] && [_userPrivacy isEqual:@"private"])) {
        _followersButton.alpha = .5;
        _followingButton.alpha = .5;
        _shoutsButton.alpha = .5;
        _statisticsButton.alpha = .5;
        _groupsButton.alpha = .5;
        _schoolsButton.alpha = .5;
        
        _groupsImage1.alpha = .5;
        _groupsImage2.alpha = .5;
        _groupsImage3.alpha = .5;
        _groupsImage4.alpha = .5;
        _groupsImage5.alpha = .5;
        _groupsImage6.alpha = .5;
        _groupsCountLabel.alpha = .5;
        
        _followingImage1.alpha = .5;
        _followingImage2.alpha = .5;
        _followingImage3.alpha = .5;
        _followingImage4.alpha = .5;
        _followingImage5.alpha = .5;
        _followingImage6.alpha = .5;
        _followingCountLabel.alpha = .5;
        
        _followersImage1.alpha = .5;
        _followersImage2.alpha = .5;
        _followersImage3.alpha = .5;
        _followersImage4.alpha = .5;
        _followersImage5.alpha = .5;
        _followersImage6.alpha = .5;
        _followersCountLabel.alpha = .5;
        
        _schoolsImageView.alpha = .5;
        _statisticsImageView.alpha = .5;
        _shoutsImageView.alpha = .5;
    }

}

- (void)alterActionButton
{
    // Action button
    if([_userRelation isEqualToString:@"you"]) {
        [_relationButton setTitle: @"Settings" forState:UIControlStateNormal];
        self.title = @"Me";
        [_relationButton setStyle:@"darkBlueStyle"];
    }
    else if([_userRelation isEqualToString:@"following"]) {
        [_relationButton setTitle: @"Following" forState:UIControlStateNormal];
        [_relationButton setStyle:@"blueStyle"];
    }
    else if([_userRelation isEqualToString:@"not_following"]) {
        if([_userPrivacy isEqual:@"private"]) {
            [_relationButton setTitle: @"Request To Follow" forState:UIControlStateNormal];
            [_relationButton setStyle:@"greyStyle"];
        }
        else {
            [_relationButton setTitle: @"Follow" forState:UIControlStateNormal];
            [_relationButton setStyle:@"greyStyle"];
        }
    }
    else if([_userRelation isEqualToString:@"pending"]) {
        [_relationButton setTitle: @"Pending Request" forState:UIControlStateNormal];
        [_relationButton setStyle:@"pendingStyle"];
    }
}

- (IBAction)loadAction:(id)sender {
    if([_userRelation isEqual:@"you"])
    {
        [self loadSettings];
    }
    else
    {
        if([_userRelation isEqual:@"following"])
        {
            [self askToUnfollow];
        }
        else if([_userRelation isEqual:@"not_following"])
        {
            if([_userPrivacy isEqual:@"private"]) {
                NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/follow", BaseURLString, [_userDict objectForKey:@"id"]];
                NSURL *url = [NSURL URLWithString:requestURLString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                [request setHTTPMethod:@"POST"];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                        _userRelation = @"pending";
                        [self alterActionButton];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self alertServerError];
                }];
                [operation start];
            }
            else {
                NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/follow",BaseURLString,[_userDict objectForKey:@"id"]];
                NSURL *url = [NSURL URLWithString:requestURLString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                [request setHTTPMethod:@"POST"];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                        _userRelation = @"following";
                        [self initializeUser];
                        [self alterActionButton];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self alertServerError];
                }];
                [operation start];
            }
        }
        else if([_userRelation isEqual:@"pending"])
        {
        }
    }
}

- (void)userUnfollow
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/unfollow",BaseURLString,[_userDict objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
            _userRelation = @"not_following";
            [self initializeUser];
            [self alterActionButton];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}
- (void)askToUnfollow
{
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"User Unfollow" message:[NSString stringWithFormat:@"Are you sure you want to unfollow %@?", [NSString stringWithFormat:@"%@",[_userDict objectForKey:@"name_first"]]] delegate: self cancelButtonTitle: @"No"  otherButtonTitles:@"Yes",nil];
    
    [updateAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self userUnfollow];
    }
}

- (IBAction)loadSettings
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithSessionCookie:_sessionCookie];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}
- (IBAction)loadFollowedUsers:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        UsersViewController *usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie userID:_userID usersType:@"Following"];
        [self.navigationController pushViewController:usersViewController animated:YES];
    }
}

- (IBAction)loadFollowers:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        UsersViewController *usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie userID:_userID usersType:@"Followers"];
        [self.navigationController pushViewController:usersViewController animated:YES];
    }
}

- (IBAction)loadGroups:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        GroupsViewController *groupsViewController;
        if([_userRelation isEqual:@"you"]) {
            groupsViewController = [[GroupsViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
        }
        else {
            groupsViewController = [[GroupsViewController alloc] initWithSessionCookie:_sessionCookie userID:_userID];
        }
        [self.navigationController pushViewController:groupsViewController animated:YES];
    }
}

- (IBAction)loadSchools:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        SchoolsViewController *schoolsViewController;
        if([_userRelation isEqual:@"you"]) {
            schoolsViewController = [[SchoolsViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
        }
        else {
            schoolsViewController = [[SchoolsViewController alloc] initWithSessionCookie:_sessionCookie userID:_userID];
        }
        [self.navigationController pushViewController:schoolsViewController animated:YES];
    }
}

- (IBAction)loadStatistics:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        UserStatisticsViewController *userStatisticsViewController = [[UserStatisticsViewController alloc] initWithSessionCookie:_sessionCookie userID:_userID];
        [self.navigationController pushViewController:userStatisticsViewController animated:YES];
    }
}

- (IBAction)loadShouts:(id)sender
{
    if([_userRelation isEqual:@"following"] || [_userPrivacy isEqual:@"public"]) {
        FeedViewController *feedViewController = [[FeedViewController alloc] initWithSessionCookie:_sessionCookie profileClass:@"User" profileID:_userID];
        [self.navigationController pushViewController:feedViewController animated:YES];
    }
}
@end
