//
//  UsersViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/17/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UsersViewController.h"
#import "UIViewController+Utilities.h"
#import "UserViewController.h"
#import "UserCell.h"
#import "GroupUserCell.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation UsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie usersArray:(NSArray *)usersArray title:(NSString *)title
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray arrayWithArray:usersArray];
        self.title = title;
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID isAdmin:(BOOL)isAdmin usersType:(NSString *)usersType
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray array];
        self.title = usersType;
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
        self.isAdmin = isAdmin;
        self.profileClass = @"Group";
        self.profileID = groupID;
        self.usersType = usersType;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie partyID:(NSString *)partyID
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray array];
        self.title = @"Attending Users";
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
        
        self.profileClass = @"Party";
        self.profileID = partyID;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray array];
        self.title = @"Attending Users";
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
        
        self.profileClass = @"Place";
        self.profileID = placeID;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray array];
        self.title = @"Users";
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
        
        self.profileClass = @"School";
        self.profileID = schoolID;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID usersType:(NSString *)usersType
{
    self = [super initWithNibName:@"UsersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.usersArray = [NSMutableArray array];
        self.title = usersType;
        self.selectedYear = @"All";
        self.usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
        
        self.profileClass = @"User";
        self.profileID = userID;
        self.usersType = usersType;
    }
    return self;
}

- (IBAction)selectYear:(id)sender {
    _usersUsedArray = [NSMutableArray array];
    switch(_segmentedControl.selectedSegmentIndex) {
        case 0:
            _selectedYear = @"All";
            break;
        case 1:
            _selectedYear = @"Freshman";
            break;
        case 2:
            _selectedYear = @"Sophomore";
            break;
        case 3:
            _selectedYear = @"Junior";
            break;
        case 4:
            _selectedYear = @"Senior";
            break;
    }
    if(_segmentedControl.selectedSegmentIndex != 0) {
        NSMutableDictionary *cellDict;
        for(int i = 0; i < [_usersArray count]; i++) {
            cellDict = _usersArray[i];
            if([[NSString stringWithFormat:@"%@",[cellDict objectForKey:@"year"]] isEqual:_selectedYear]) {
                [_usersUsedArray addObject:cellDict];
            }
        }
    }
    else {
        _usersUsedArray = [NSMutableArray arrayWithArray:_usersArray];
    }
    [_tableView beginUpdates];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.title;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self updateUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUsers
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    if([_profileClass isEqual:@"Group"]) {
        if([_usersType isEqual:@"Admins"]) {
            NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/admins.json", BaseURLString,_profileID];
            NSURL *url = [NSURL URLWithString:requestURLString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setAllHTTPHeaderFields:headers];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request setHTTPMethod:@"GET"];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                _usersArray  = (NSMutableArray *)JSON;
                _usersUsedArray = _usersArray;
                [_tableView reloadData];
                [self selectYear:nil];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self alertServerError];
            }];
            [operation start];
        }
        else if([_usersType isEqual:@"Members"]) {
            NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/members.json", BaseURLString,_profileID];
            NSURL *url = [NSURL URLWithString:requestURLString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setAllHTTPHeaderFields:headers];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request setHTTPMethod:@"GET"];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                _usersArray  = (NSMutableArray *)JSON;
                _usersUsedArray = _usersArray;
                [_tableView reloadData];
                [self selectYear:nil];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self alertServerError];
            }];
            [operation start];
        }
    }
    else if([_profileClass isEqual:@"Party"]) {  
        NSString *requestURLString = [NSString stringWithFormat:@"%@/parties/%@/attending_users.json", BaseURLString,_profileID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _usersArray  = (NSMutableArray *)JSON;
            _usersUsedArray = _usersArray;
            [_tableView reloadData];
            [self selectYear:nil];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
    else if([_profileClass isEqual:@"Place"]) {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/places/%@/attending_users.json", BaseURLString,_profileID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _usersArray  = (NSMutableArray *)JSON;
            _usersUsedArray = _usersArray;
            [_tableView reloadData];
            [self selectYear:nil];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
    else if([_profileClass isEqual:@"School"]) {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/%@/users.json", BaseURLString,_profileID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _usersArray  = (NSMutableArray *)JSON;
            _usersUsedArray = _usersArray;
            [_tableView reloadData];
            [self selectYear:nil];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
    else if([_profileClass isEqual:@"User"]) {
        if([_usersType isEqual:@"Following"]) {
            NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/followed_users.json", BaseURLString,_profileID];
            NSURL *url = [NSURL URLWithString:requestURLString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setAllHTTPHeaderFields:headers];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request setHTTPMethod:@"GET"];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                _usersArray  = (NSMutableArray *)JSON;
                _usersUsedArray = _usersArray;
                [_tableView reloadData];
                [self selectYear:nil];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self alertServerError];
            }];
            [operation start];
        }
        else if([_usersType isEqual:@"Followers"]) {
            NSString *requestURLString = [NSString stringWithFormat:@"%@/users/%@/followers.json", BaseURLString,_profileID];
            NSURL *url = [NSURL URLWithString:requestURLString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setAllHTTPHeaderFields:headers];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request setHTTPMethod:@"GET"];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                _usersArray  = (NSMutableArray *)JSON;
                _usersUsedArray = _usersArray;
                [_tableView reloadData];
                [self selectYear:nil];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self alertServerError];
            }];
            [operation start];
        }
    }
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
    if([_profileClass isEqual:@"Group"] && _isAdmin) {
        GroupUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupUserCell"];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupUserCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.userID = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [cell.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
        
        // Name Label
        cell.nameLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        // School Label
        if(![[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"] isEqual:[NSNull null]]) {
            cell.schoolLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"];
        }
        
        // Admin Buttons
        if(![[NSString stringWithFormat:@"%@",[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"relation"]] isEqual:@"you"]) {
            // Kick Button
            [cell.kickButton addTarget:self action:@selector(kickUser:) forControlEvents:UIControlEventTouchUpInside];
            cell.kickButton.objectID = [NSString stringWithFormat:@"%@",[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            // Admin Button
            [cell.kickButton setStyle:@"greyStyle"];
            if([[NSString stringWithFormat:@"%@",[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"is_admin"]] isEqual:@"1"]) {
                [cell.adminButton setStyle:@"blueStyle"];
                [cell.adminButton addTarget:self action:@selector(demoteUser:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [cell.adminButton setStyle:@"greyStyle"];
                [cell.adminButton addTarget:self action:@selector(promoteUser:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.adminButton.objectID = [NSString stringWithFormat:@"%@",[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
        }
        else {
            cell.kickButton.hidden = YES;
            cell.adminButton.hidden = YES;
        }
        
        // Set default border radius.
        CALayer * layer = [cell.imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        layer = [cell.kickButton layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        layer = [cell.adminButton layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        return cell;
    }
    else {
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.userID = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        if(![cell.userID isKindOfClass:[NSNull class]]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [cell.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
        
        cell.nameLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        if(![[[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"] isEqual:[NSNull null]]) {
            cell.schoolLabel.text = [[_usersUsedArray objectAtIndex:indexPath.row] objectForKey:@"primary_school"];
        }
        else {
            cell.schoolLabel.hidden = YES;
        }
        
        // Add AccessoryView
        if(![cell.userID isKindOfClass:[NSNull class]]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // Set default border radius.
        CALayer * layer = [cell.userImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        return cell;
    }
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(![cell.userID isKindOfClass:[NSNull class]]) {
        UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@", cell.userID]];
        [self.navigationController pushViewController:userViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)kickUser:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/user_remove", BaseURLString, _profileID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *postBody = [[NSString stringWithFormat:@"<user_id>%@</user_id>", sender.objectID] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self updateUsers];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     }
     ];
    [operation start];
}
- (void)promoteUser:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/admin_add", BaseURLString, _profileID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *postBody = [[NSString stringWithFormat:@"<user_id>%@</user_id>", sender.objectID] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self updateUsers];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [operation start];
}
- (void)demoteUser:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@/admin_remove", BaseURLString, _profileID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *postBody = [[NSString stringWithFormat:@"<user_id>%@</user_id>", sender.objectID] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self updateUsers];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [operation start];
}

@end
