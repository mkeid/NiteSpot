//
//  SchoolViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolViewController.h"
#import "UIViewController+Utilities.h"
#import "GroupsViewController.h"
#import "GroupPartiesViewController.h"
#import "SchoolPlacesViewController.h"
#import "UsersViewController.h"
#import "NiteSiteButton.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SchoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolHandle:(NSString *)schoolHandle{
    self = [super initWithNibName:@"SchoolViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.schoolHandle = schoolHandle;
    }
    return self;
}
- (void)initializeSchool
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/schools/%@.json", BaseURLString, _schoolHandle] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"School";
    [_usersButton setStyle:@"whiteStyle"];
    [_groupsButton setStyle:@"whiteStyle"];
    [_statisticsButton setStyle:@"whiteStyle"];
    [_partiesButton setStyle:@"whiteStyle"];
    [_placesButton setStyle:@"whiteStyle"];
    
    // Hide statistics button for now.
    _statisticsButton.hidden = YES;
    
    // Font
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"";
    
    _groupsCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _groupsCountLabel.textAlignment = NSTextAlignmentCenter;
    _groupsCountLabel.textColor =  [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _partiesCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _partiesCountLabel.textAlignment = NSTextAlignmentCenter;
    _partiesCountLabel.textColor =  [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _placesCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _placesCountLabel.textAlignment = NSTextAlignmentCenter;
    _placesCountLabel.textColor =  [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    _usersCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _usersCountLabel.textAlignment = NSTextAlignmentCenter;
    _usersCountLabel.textColor =  [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    
    // Set default border radius.
    CALayer * layer = [_schoolImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.scrollEnabled = NO;
    [self initializeSchool];
}

- (void)updateSchool
{
    _relation = [_schoolDict objectForKey:@"relation"];
    _nameLabel.text = [_schoolDict objectForKey:@"name"];
    [_schoolImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[_schoolDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"schoolAvatar.png"]];

    [self alterActionButton];
    
    NSMutableDictionary *sampleObject;
    NSMutableArray *sampleArray;
    NSMutableDictionary *sampleDict;
    
    // Groups
    _groupsCountLabel.text = [NSString stringWithFormat:@"%@", [_schoolDict objectForKey:@"group_count"]];
    sampleDict = [_schoolDict objectForKey:@"group_sample"];
    sampleArray = [_schoolDict objectForKey:@"group_sample"];
    if([sampleDict count] > 0) {
        sampleObject = sampleArray[0];
        [_groupImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 1) {
        sampleObject = sampleArray[1];
        [_groupImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 2) {
        sampleObject = sampleArray[2];
        [_groupImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];    }
    if([sampleDict count] > 3) {
        sampleObject = sampleArray[3];
        [_groupImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 4) {
        sampleObject = sampleArray[4];
       [_groupImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 5) {
        sampleObject = sampleArray[5];
        [_groupImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Parties
    _partiesCountLabel.text = [NSString stringWithFormat:@"%@", [_schoolDict objectForKey:@"party_count"]];
    sampleDict = [_schoolDict objectForKey:@"party_sample"];
    sampleArray = [_schoolDict objectForKey:@"party_sample"];
    if([sampleDict count] > 0) {
        sampleObject = sampleArray[0];
        [_partyImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 1) {
        sampleObject = sampleArray[1];
        [_partyImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 2) {
        sampleObject = sampleArray[2];
        [_partyImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];    }
    if([sampleDict count] > 3) {
        sampleObject = sampleArray[3];
        [_partyImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];    }
    if([sampleDict count] > 4) {
        sampleObject = sampleArray[4];
        [_partyImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];    }
    if([sampleDict count] > 5) {
        sampleObject = sampleArray[5];
       [_partyImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Places
    _placesCountLabel.text = [NSString stringWithFormat:@"%@", [_schoolDict objectForKey:@"place_count"]];
    sampleDict = [_schoolDict objectForKey:@"place_sample"];
    sampleArray = [_schoolDict objectForKey:@"place_sample"];
    if([sampleDict count] > 0) {
        sampleObject = sampleArray[0];
        [_placeImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 1) {
        sampleObject = sampleArray[1];
        [_placeImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 2) {
        sampleObject = sampleArray[2];
        [_placeImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 3) {
        sampleObject = sampleArray[3];
        [_placeImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 4) {
        sampleObject = sampleArray[4];
        [_placeImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 5) {
        sampleObject = sampleArray[5];
        [_placeImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    // Users
    _usersCountLabel.text = [NSString stringWithFormat:@"%@", [_schoolDict objectForKey:@"user_count"]];
    sampleDict = [_schoolDict objectForKey:@"user_sample"];
    sampleArray = [_schoolDict objectForKey:@"user_sample"];
    if([sampleDict count] > 0) {
        sampleObject = sampleArray[0];
        [_userImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 1) {
        sampleObject = sampleArray[1];
        [_userImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 2) {
        sampleObject = sampleArray[2];
        [_userImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 3) {
        sampleObject = sampleArray[3];
        [_userImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 4) {
        sampleObject = sampleArray[4];
        [_userImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([sampleDict count] > 5) {
        sampleObject = sampleArray[5];
        [_userImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    
    if([_relation isEqual:@"pending"] || [_relation isEqual:@"not_in_school"]) {
        _groupsButton.alpha = .5;
        _groupImage1.alpha = .5;
        _groupImage2.alpha = .5;
        _groupImage3.alpha = .5;
        _groupImage4.alpha = .5;
        _groupImage5.alpha = .5;
        _groupImage6.alpha = .5;
        
        _partiesButton.alpha = .5;
        _partyImage1.alpha = .5;
        _partyImage2.alpha = .5;
        _partyImage3.alpha = .5;
        _partyImage4.alpha = .5;
        _partyImage5.alpha = .5;
        _partyImage6.alpha = .5;
        
        _placesButton.alpha = .5;
        _placeImage1.alpha = .5;
        _placeImage2.alpha = .5;
        _placeImage3.alpha = .5;
        _placeImage4.alpha = .5;
        _placeImage5.alpha = .5;
        _placeImage6.alpha = .5;
        
        _usersButton.alpha = .5;
        _userImage1.alpha = .5;
        _userImage2.alpha = .5;
        _userImage3.alpha = .5;
        _userImage4.alpha = .5;
        _userImage5.alpha = .5;
        _userImage6.alpha = .5;
        
        _statisticsButton.alpha = .5;
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
    _schoolDict = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:nil];
    [self updateSchool];
}
//

- (IBAction)loadGroups:(id)sender {
    if([_relation isEqual:@"in_school"]) {
        GroupsViewController *groupsViewController = [[GroupsViewController alloc] initWithSessionCookie:_sessionCookie schoolID:_schoolHandle];
        [self.navigationController pushViewController:groupsViewController animated:YES];
    }
}

- (IBAction)loadParties:(id)sender {
    if([_relation isEqual:@"in_school"]) {
        GroupPartiesViewController *groupPartiesViewController = [[GroupPartiesViewController alloc] initWithSessionCookie:_sessionCookie schoolID:_schoolHandle];
        [self.navigationController pushViewController:groupPartiesViewController animated:YES];
    }
}

- (IBAction)loadPlaces:(id)sender {
    if([_relation isEqual:@"in_school"]) { 
        SchoolPlacesViewController *schoolPlacesViewController = [[SchoolPlacesViewController alloc] initWithSessionCookie:_sessionCookie schoolID:_schoolHandle];
        [self.navigationController pushViewController:schoolPlacesViewController animated:YES];
    }
}

- (IBAction)loadUsers:(id)sender {
    if([_relation isEqual:@"in_school"]) {
        UsersViewController *usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie schoolID:_schoolHandle];
        [self.navigationController pushViewController:usersViewController animated:YES];
    }
}

- (IBAction)loadStatistics:(id)sender {
    
}

- (void)alterActionButton
{
    // Action button
    if([_relation isEqualToString:@"in_school"]) {
        [_actionButton setTitle: @"Joined" forState:UIControlStateNormal];
        [_actionButton setStyle:@"blueStyle"];
    }
    else if([_relation isEqualToString:@"not_member"]) {
        [_actionButton setTitle: @"Ask To Join" forState:UIControlStateNormal];
        [_actionButton setStyle:@"greyStyle"];
    }
    else if([_relation isEqualToString:@"pending"]) {
        [_actionButton setTitle: @"Pending Request" forState:UIControlStateNormal];
        [_actionButton setStyle:@"pendingStyle"];
    }
}
- (IBAction)loadAction:(id)sender
{
    if([_relation isEqual:@"not_in_school"])
    {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/%@/ask_to_join",BaseURLString,_schoolHandle];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                _relation = @"pending";
                [self alterActionButton];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
        }];
        [operation start];
    }
}
@end
