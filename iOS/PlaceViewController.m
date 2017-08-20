//
//  PlaceViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlaceViewController.h"
#import "UIViewController+Utilities.h"
#import "UsersViewController.h"
#import "PlaceTopAttendeesViewController.h"
#import "PlaceStatisticsViewController.h"
#import "NiteSiteButton.h"
#import "UIImageView+AFNetworking.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation PlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID{
    self = [super initWithNibName:@"PlaceViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placeID = placeID;
    }
    return self;
}
- (void)initializePlace
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 0;
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/places/%@.json", BaseURLString, _placeID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Place";
    [_attendingUsersButton setStyle:@"whiteStyle"];
    [_topAttendeesButton setStyle:@"whiteStyle"];
    [_statisticsButton setStyle:@"whiteStyle"];
    
    // Font
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"";
    
    _typeLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.text = @"";
    
    _attendingUsersCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _attendingUsersCountLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    _attendingUsersCountLabel.textAlignment = NSTextAlignmentCenter;
    
    // Set default border radius.
    CALayer * layer = [_placeImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [_statisticsImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializePlace];
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
    if(_HTTPTag == 0) {
        NSString *placeInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        NSData *data = [placeInfo dataUsingEncoding:NSUTF8StringEncoding];
        _placeDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self updatePlace];
    }
}

- (void)updatePlace
{
    [_placeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_placeDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"placeAvatar.png"]];
 
    _relation = [_placeDict objectForKey:@"relation"];
    _nameLabel.text = [_placeDict objectForKey:@"name"];
    _typeLabel.text = [_placeDict objectForKey:@"kind"];
    
    [self alterActionButton];
    
    
    NSMutableDictionary *sampleObject;
    // Attending Users
    if([[NSString stringWithFormat:@"%@",[_placeDict objectForKey:@"has_voted"]] isEqual:@"1"] ) {
        NSString *attendingUsersCount = [NSString stringWithFormat:@"%@",[_placeDict objectForKey:@"attending_users_count"]];
        _attendingUsersCountLabel.text = attendingUsersCount;
        NSDictionary *attendingUsersSampleDict = [_placeDict objectForKey:@"attending_users_sample"];
        NSArray *attendingUsersSampleArray = [_placeDict objectForKey:@"attending_users_sample"];
        if([attendingUsersCount isEqual: @"1"]) {
            [_attendingUsersButton setTitle: @"Attending User" forState:UIControlStateNormal];
        }
        if([attendingUsersSampleDict count] > 0) {
            sampleObject = attendingUsersSampleArray[0];
            [_attendingUserImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
        if([attendingUsersSampleDict count] > 1) {
            sampleObject = attendingUsersSampleArray[1];
           [_attendingUserImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
        if([attendingUsersSampleDict count] > 2) {
            sampleObject = attendingUsersSampleArray[2];
            [_attendingUserImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
        if([attendingUsersSampleDict count] > 3) {
            sampleObject = attendingUsersSampleArray[3];
            [_attendingUserImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
        if([attendingUsersSampleDict count] > 4) {
            sampleObject = attendingUsersSampleArray[4];
            [_attendingUserImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
        if([attendingUsersSampleDict count] > 5) {
            sampleObject = attendingUsersSampleArray[5];
            [_attendingUserImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
        }
    }
    else {
        _attendingUserImage1.hidden = YES;
        _attendingUserImage2.hidden = YES;
        _attendingUserImage3.hidden = YES;
        _attendingUserImage4.hidden = YES;
        _attendingUserImage5.hidden = YES;
        _attendingUserImage6.hidden = YES;
        _attendingUsersCountLabel.hidden = YES;
        _attendingUsersButton.hidden = YES;
    }
    
    // Top Attendees
    NSDictionary *topAttendeesSampleDict = [_placeDict objectForKey:@"top_attendees_sample"];
    NSArray *topAttendeesSampleArray = [_placeDict objectForKey:@"top_attendees_sample"];
    if([topAttendeesSampleDict count] > 0) {
        sampleObject = topAttendeesSampleArray[0];
        [_topAttendeeImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([topAttendeesSampleDict count] > 1) {
        sampleObject = topAttendeesSampleArray[1];
        [_topAttendeeImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([topAttendeesSampleDict count] > 2) {
        sampleObject = topAttendeesSampleArray[2];
        [_topAttendeeImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([topAttendeesSampleDict count] > 3) {
        sampleObject = topAttendeesSampleArray[3];
        [_topAttendeeImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([topAttendeesSampleDict count] > 4) {
        sampleObject = topAttendeesSampleArray[4];
        [_topAttendeeImage5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
    if([topAttendeesSampleDict count] > 5) {
        sampleObject = topAttendeesSampleArray[5];
       [_topAttendeeImage6 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[sampleObject objectForKey:@"avatar_location"]]]];
    }
}

- (IBAction)loadAttendingUsers:(id)sender {
    UsersViewController *usersViewController = [[UsersViewController alloc] initWithSessionCookie:_sessionCookie placeID:_placeID];
    [self.navigationController pushViewController:usersViewController animated:YES];
}
- (IBAction)loadTopAttendees:(id)sender {
    PlaceTopAttendeesViewController *placeTopAttendeesViewController = [[PlaceTopAttendeesViewController alloc] initWithSessionCookie:_sessionCookie placeID:_placeID];
    [self.navigationController pushViewController:placeTopAttendeesViewController animated:YES];
}
- (IBAction)loadStatistics:(id)sender {
    PlaceStatisticsViewController *placeStatisticsViewController = [[PlaceStatisticsViewController alloc] initWithSessionCookie:_sessionCookie placeID:_placeID];
    [self.navigationController pushViewController:placeStatisticsViewController animated:YES];
}

- (void)alterActionButton
{
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
- (IBAction)loadAction:(id)sender
{
    if([_relation isEqual:@"not_attending"])
    {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/places/%@/attend",BaseURLString,[_placeDict objectForKey:@"id"]];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
                _relation = @"attending";
                [self initializePlace];
                [self alterActionButton];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
        }];
        [operation start];
    }
}


@end
