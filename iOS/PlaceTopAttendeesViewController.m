//
//  PlaceTopAttendeesViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/25/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlaceTopAttendeesViewController.h"
#import "UIViewController+Utilities.h"
#import "UserStatisticCell.h"
#import "UserViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation PlaceTopAttendeesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID
{
    self = [super initWithNibName:@"PlaceTopAttendeesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placeID = placeID;
        self.selectedYear = @"all";
        self.usersUsedArray = [NSArray array];
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie usersDict:(NSDictionary *)usersDict
{
    self = [super initWithNibName:@"PlaceTopAttendeesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersDict = usersDict;
        self.selectedYear = @"all";
        self.usersUsedArray = [_usersDict objectForKey:@"top_all"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Top Attendees";
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_placeID != nil) {
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
        NSString *requestURLString = [NSString stringWithFormat:@"%@/places/%@/top_attendees.json", BaseURLString,_placeID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _usersDict  = (NSDictionary *)JSON;
            _usersUsedArray = [_usersDict objectForKey:@"top_all"];
            [_tableView reloadData];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectYear:(id)sender
{
    switch(_segmentedControl.selectedSegmentIndex) {
        case 0:
            _selectedYear = @"all";
            _usersUsedArray = [_usersDict objectForKey:@"top_all"];
            break;
        case 1:
            _selectedYear = @"Freshman";
            _usersUsedArray = [_usersDict objectForKey:@"top_freshmen"];
            break;
        case 2:
            _selectedYear = @"Sophomore";
            _usersUsedArray = [_usersDict objectForKey:@"top_sophomores"];
            break;
        case 3:
            _selectedYear = @"Junior";
            _usersUsedArray = [_usersDict objectForKey:@"top_juniors"];
            break;
        case 4:
            _selectedYear = @"Senior";
            _usersUsedArray = [_usersDict objectForKey:@"top_seniors"];
            break;
    }
    [_tableView beginUpdates];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewAutomaticDimension];
    [_tableView endUpdates];
}

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_usersUsedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserStatisticCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserStatisticCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.userID = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    
    cell.nameLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.schoolLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"];
    
    cell.attendanceCountLabel.text = [NSString stringWithFormat:@"%@", [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"attendance_count"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Set default border radius.
    CALayer * layer = [cell.userImageView layer];
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
    return 50;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserStatisticCell *cell = (UserStatisticCell *)[tableView cellForRowAtIndexPath:indexPath];
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@", cell.userID]];
    [self.navigationController pushViewController:userViewController animated:YES];
}


@end
