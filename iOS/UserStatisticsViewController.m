//
//  UserStatisticsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/19/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UserStatisticsViewController.h"
#import "PlaceViewController.h"
#import "UserStatisticsCell.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation UserStatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID {
    self = [super initWithNibName:@"UserStatisticsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.userID = userID;
        self.placesArray = [NSArray array];
        self.title = @"Statistics";
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie statsDict:(NSDictionary *)statsDict {
    self = [super initWithNibName:@"UserStatisticsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placesArray = [statsDict objectForKey:@"places"];
        self.title = @"Statistics";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_userID != nil) {
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
                
        NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/statistics.json", BaseURLString, _userID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *statsDict = (NSDictionary *)JSON;
            _placesArray  = [statsDict objectForKey:@"places"];
            [_tableView reloadData];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Oops!"
                                       message:@"There was a server error."
                                       delegate:nil
                                       cancelButtonTitle:@"Ok."
                                       otherButtonTitles:nil];
            [errorAlert show];
        }];
        [operation start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserStatisticsCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserStatisticsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.placeID = [[_placesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_placesArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.placeImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[_placesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.kindLabel.text = [NSString stringWithFormat:@"%@",[[_placesArray objectAtIndex:indexPath.row] objectForKey:@"kind"]];
    cell.attendanceCountLabel.text = [NSString stringWithFormat:@"%@",[[_placesArray objectAtIndex:indexPath.row] objectForKey:@"user_attendance_count"]];
    
    // Set default border radius.
    CALayer * layer = [cell.placeImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    layer = [cell.attendanceCountLabel layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UserStatisticsCell *cell = (UserStatisticsCell *)[tableView cellForRowAtIndexPath:indexPath];
    PlaceViewController *placeViewController = [[PlaceViewController alloc] initWithSessionCookie:_sessionCookie placeID:[NSString stringWithFormat:@"%@", cell.placeID]];
    [self.navigationController pushViewController:placeViewController animated:YES];
}

@end
