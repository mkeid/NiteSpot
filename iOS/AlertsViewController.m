//
//  AlertsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//
#import "AlertsViewController.h"
#import "UIViewController+Utilities.h"
#import "NotificationCell.h"
#import "RequestCell.h"
#import "DDMenuController.h"
#import "NiteSiteNavigationController.h"
#import "AppDelegate.h"
#import "GroupViewController.h"
#import "ShoutViewController.h"
#import "PartyViewController.h"
#import "UserViewController.h"
#import "SearchViewController.h"
#import "NiteSiteButton.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""


@implementation AlertsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie {
    self = [super initWithNibName:@"AlertsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.alertType = @"notification";
        self.hasFinishedLoading = YES;
        self.alertsArray = [NSArray array];
    }
    [self initAttributes];
    return self;
}

- (void)initAttributes
{
    // Message
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *timeFont = [UIFont systemFontOfSize:10];
    UIColor *foregroundColor = [UIColor colorWithRed:.588 green:.8157 blue:.2863 alpha:1];
    UIColor *timeColor = [UIColor colorWithRed:.67 green:.67 blue:.67 alpha:1];
    UIColor *timeBGColor = [UIColor colorWithRed:.157 green:.157 blue:.157 alpha:1];
    
    // Create the attributes
    _nameAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               boldFont, NSFontAttributeName,
                               foregroundColor, NSForegroundColorAttributeName, nil];
    _subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,nil];
    _timeAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               timeFont, NSFontAttributeName, timeColor, NSForegroundColorAttributeName, timeBGColor, NSBackgroundColorAttributeName, nil];
    _uncheckedAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                  boldFont, NSFontAttributeName, [UIColor colorWithRed:.05 green:.05 blue:.05 alpha:1], NSForegroundColorAttributeName, [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1], NSBackgroundColorAttributeName, nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    //DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    switch(_segmentedControl.selectedSegmentIndex) {
        case 0:
            [self loadNotifications];
            break;
        case 1:
            [self loadRequests];
            break;
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
    NSString *alertsInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [alertsInfo dataUsingEncoding:NSUTF8StringEncoding];
    if(_HTTPTag == 0 || _HTTPTag == 1) { // load notifications or requests
        _hasFinishedLoading = YES;
        _alertsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(_HTTPTag == 0) { // if notifications
            _notificationCount = 0;
            [self updateNotificationCount:0];
            [_segmentedControl setTitle:[NSString stringWithFormat:@"Notifications: 0"] forSegmentAtIndex:0];
        }
        if([[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] count] < 30) {
            _loadedMaxAlerts = YES;
            if(_HTTPTag == 1) {
                [self updateRequestCount:[_alertsArray count]];
            }
        }
        else {
            _loadedMaxAlerts = NO;
        }
        [self.tableView reloadData];
    }
    else if(_HTTPTag == 2) { // refresh notifications
        
    }
    else if(_HTTPTag == 4) { // get old notifications
        _reachedBottom = NO;
    }
}

- (IBAction)loadAlerts:(id)sender {
    if(_hasFinishedLoading == YES) {
        switch(_segmentedControl.selectedSegmentIndex) {
            case 0:
                [self loadNotifications];
                break;
            case 1:
                [self loadRequests];
                break;
        }
    }
    else {
        if([_alertType isEqual:@"notification"]) {
            [_segmentedControl setSelectedSegmentIndex:0];
        }
        else if([_alertType isEqual:@"request"]) {
            [_segmentedControl setSelectedSegmentIndex:1];
        }
    }
}

- (void)loadNotifications
{
    _hasFinishedLoading = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 0;
    _alertType = @"notification";
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/notifications/list.json", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)getNewNotifications
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)getOldNotifications
{
    _HTTPTag = 4;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDictionary *alertDict = [_alertsArray objectAtIndex:0];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/notifications/list.json?kind=old&created_at=%@&count=%d", BaseURLString, [alertDict objectForKey:@"created_at"], [_alertsArray count]] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)loadRequests
{
    _hasFinishedLoading = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 1;
    _alertType = @"request";    
   [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/requests/list.json", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}
- (void)getNewRequests
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)getOldRequests
{
    _alertType = @"request";
    NSDictionary *alertDict = [_alertsArray objectAtIndex:0];
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/requests/list.json?kind=old&created_at=%@", BaseURLString, [alertDict objectForKey:@"created_at"]];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if(([(NSArray *)JSON count]-[_alertsArray count]) < 30) {
            _loadedMaxAlerts = YES;
        }
        _alertsArray = (NSArray *)JSON;
        [self.tableView reloadData];
        _reachedBottom = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if([_alertsArray count]>= 30) {
        CGPoint offset = self.tableView.contentOffset;
        CGRect bounds = self.tableView.bounds;
        CGSize size = self.tableView.contentSize;
        UIEdgeInsets inset = self.tableView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        if(y > h - 1000 && !_reachedBottom && !_loadedMaxAlerts) {
            NSLog(@"loading rows");
            _reachedBottom = YES;
            if([_alertType isEqual:@"notification"]) {
                [self getOldNotifications];
            }
            else if([_alertType isEqual:@"request"]) {
                [self getOldRequests];
            }
        }
    }
}

- (void)updateNotificationCount:(int)count
{
    _notificationCount = count;
    [_segmentedControl setTitle:[NSString stringWithFormat:@"Notifications: %d",count] forSegmentAtIndex:0];
    [self updateAlertCount];
}

- (void)updateRequestCount:(int)count
{
    _requestCount = count;
    [_segmentedControl setTitle:[NSString stringWithFormat:@"Requests: %d",count] forSegmentAtIndex:1];
    [self updateAlertCount];
}

- (void)updateAlertCount
{
    NiteSiteButton *alertsButton = [[NiteSiteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [alertsButton addTarget:self action:@selector(openAlerts) forControlEvents:UIControlEventTouchUpInside];
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/me/alert_count.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *alertsCountDict  = (NSDictionary *)JSON;
        NSString *notificationsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"notifications"]];
        NSString *requestsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"requests"]];
        int alertsCount = [notificationsCount intValue]+[requestsCount intValue];
        
        // Set Number of alerts in button.
        [alertsButton setTitle:[NSString stringWithFormat:@"%d", alertsCount] forState:UIControlStateNormal];
        
        // Set button style/image
        if(alertsCount == 0) {
            [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton1.png"] forState:UIControlStateNormal];
        }
        else {
            [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton2.png"] forState:UIControlStateNormal];
        }
        [alertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [alertsButton.titleLabel setFont:[UIFont fontWithName:@"Arial-Bold" size:18]];
        
        // Set number of alerts in controller
        AlertsViewController *alertsViewController = (AlertsViewController *)menuController.rightViewController;
        [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Notifications: %@", notificationsCount] forSegmentAtIndex:0];
        alertsViewController.notificationCount = [notificationsCount intValue];
        
        [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Requests: %@", requestsCount] forSegmentAtIndex:1];
        alertsViewController.requestCount = [requestsCount intValue];
        
        alertsViewController.notificationCount = [notificationsCount intValue];
        alertsViewController.requestCount = [requestsCount intValue];
        
        NiteSiteNavigationController *navControler = (NiteSiteNavigationController *)menuController.rootViewController;
        NSArray *viewControllers = navControler.viewControllers;
        UIViewController *currentViewController = [viewControllers objectAtIndex:[viewControllers count]-1];
        
        currentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:alertsButton];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

- (void)acceptRequest:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/requests/%@/accept", BaseURLString, sender.objectID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self loadRequests];
         
         UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:@"Success"
                                    message:@"The request was accepted."
                                    delegate:nil
                               cancelButtonTitle:@"Ok."
                               otherButtonTitles:nil];
         [alert show];
         [self updateRequestCount:_requestCount-1];
         if([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber-1];
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             }
     ];
    [operation start];
}

- (void)denyRequest:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/requests/%@/destroy", BaseURLString, sender.objectID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self loadRequests];
         [self updateRequestCount:_requestCount-1];
         if([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber-1];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [operation start];
}

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_alertsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_alertType isEqual:@"notification"]) {
        
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSDictionary *alertDict = [_alertsArray objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString, [alertDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];

        [cell.imageView setClipsToBounds:YES];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.notificationType = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"kind"]];
        
        if([cell.notificationType isEqual:@"follow_accept"] || [cell.notificationType isEqual:@"user_follow"]) {
            cell.referenceID = [alertDict objectForKey:@"from_user"];
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_user"];
            [cell.avatarButton addTarget:self action:@selector(loadUser:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([cell.notificationType isEqual:@"party_invite"]) {
            cell.referenceID = [alertDict objectForKey:@"from_party"];
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_group"];
            [cell.avatarButton addTarget:self action:@selector(loadGroup:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([cell.notificationType isEqual:@"shout_like"]) {
            cell.referenceID = [alertDict objectForKey:@"shout_liked"];
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_user"];
            [cell.avatarButton addTarget:self action:@selector(loadUser:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([cell.notificationType isEqual:@"group_membership_accept"] || [cell.notificationType isEqual:@"partyInvite"]) {
            cell.referenceID = [alertDict objectForKey:@"from_group"];
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_group"];
            [cell.avatarButton addTarget:self action:@selector(loadGroup:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _nameText = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"name"]];
        _timeText = [NSString stringWithFormat:@"%@" ,[alertDict objectForKey:@"time"]];
        if([[alertDict objectForKey:@"kind"] isEqual:@"follow_accept"]) {
            _regText = @" accepted your follow request ";
        }
        else if([[alertDict objectForKey:@"kind"] isEqual:@"group_membership_accept"]) {
            _regText = @" accepted your membership request ";
        }
        else if([[alertDict objectForKey:@"kind"] isEqual:@"party_invite"]) {
            _regText = @" invited you to its party ";
        }
        else if([[alertDict objectForKey:@"kind"] isEqual:@"shout_like"]) {
            _regText = @" liked your shout ";
        }
        else if([[alertDict objectForKey:@"kind"] isEqual:@"user_follow"]) {
            _regText = @" started following you ";
        }
        
        NSMutableAttributedString *attributedNameText = [[NSMutableAttributedString alloc] initWithString:_nameText attributes:_nameAttrs];
        NSMutableAttributedString *attributedRegularText = [[NSMutableAttributedString alloc] initWithString:_regText attributes:_subAttrs];
        NSMutableAttributedString *attributedTimeText = [[NSMutableAttributedString alloc] initWithString:_timeText attributes:_timeAttrs];
        [attributedNameText appendAttributedString:attributedRegularText];
        [attributedNameText appendAttributedString:attributedTimeText];
        if([[NSString stringWithFormat:@"%@",[alertDict objectForKey:@"unchecked"]] isEqual:@"1"]) {
            NSMutableAttributedString *attributedNewText = [[NSMutableAttributedString alloc] initWithString:@"new" attributes:_uncheckedAttrs];
            // Empty attr string
            NSMutableAttributedString *spaceText = [[NSMutableAttributedString alloc] initWithString:@" " attributes:_subAttrs];
            [attributedNameText appendAttributedString:spaceText];
            [attributedNameText appendAttributedString:attributedNewText];
        }
        [cell.messageLabel setAttributedText:attributedNameText];
        
        // Set default border radius.
        CALayer * layer = [cell.imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        if([[NSString stringWithFormat:@"%@",[alertDict objectForKey:@"unchecked"]] isEqual:@"1"] && [UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber-1];
        }
        
        
        return cell;
    }
    else if([_alertType isEqual:@"request"]) {
        RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDictionary *alertDict = [_alertsArray objectAtIndex:indexPath.row];
        cell.requestID = [alertDict objectForKey:@"id"];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[alertDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];

        [cell.imageView setClipsToBounds:YES];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.requestType = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"kind"]];
        
        // Message Label
        _nameText = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"name"]];
        _timeText = [NSString stringWithFormat:@"%@" ,[alertDict objectForKey:@"time"]];
        if([cell.requestType isEqual:@"group_invite"]) {
            _regText = @" wants you to join its group. ";
            cell.referenceID = [alertDict objectForKey:@"from_group"];
        }
        else if([cell.requestType isEqual:@"user_follow"]) {
            _regText = @" wants to follow you. ";
            cell.referenceID = [alertDict objectForKey:@"from_user"];
        }
 
        _entireText = [NSString stringWithFormat:@"%@ %@ %@",_nameText, _regText, _timeText];
        NSMutableAttributedString *attributedNameText = [[NSMutableAttributedString alloc] initWithString:_nameText attributes:_nameAttrs];
        NSMutableAttributedString *attributedRegularText = [[NSMutableAttributedString alloc] initWithString:_regText attributes:_subAttrs];
        NSMutableAttributedString *attributedTimeText = [[NSMutableAttributedString alloc] initWithString:_timeText attributes:_timeAttrs];
        [attributedNameText appendAttributedString:attributedRegularText];
        [attributedNameText appendAttributedString:attributedTimeText];
        [cell.messageLabel setAttributedText:attributedNameText];
        
        // Avatar Button
        if([cell.requestType isEqual:@"user_follow"]) {
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_user"];
            [cell.avatarButton addTarget:self action:@selector(loadUser:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([cell.requestType isEqual:@"group_invite"]) {
            cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_group"];
            [cell.avatarButton addTarget:self action:@selector(loadGroup:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // Accept / Deny Buttons
        cell.acceptButton.tag = indexPath.row;
        cell.acceptButton.objectID = [alertDict objectForKey:@"id"];
        [cell.acceptButton addTarget:self action:@selector(acceptRequest:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        cell.denyButton.tag = indexPath.row;
        cell.denyButton.objectID = [alertDict objectForKey:@"id"];
        [cell.denyButton addTarget:self action:@selector(denyRequest:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        // Set button styles.
        [cell.acceptButton setStyle:@"blueStyle"];
        [cell.denyButton setStyle:@"greenStyle"];
        
        // Set default border radius.
        CALayer * layer = [cell.imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.0];
        
        return cell;
    }
    else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_alertType isEqual:@"notification"]) {
         return 70;
    }
    else {
        return 100;
    }
}

// Loading Profiles
- (void)loadGroup:(NiteSiteButton *)sender
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@",sender.objectID]];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:groupViewController];
    [menuController setRootController:navController animated:YES];
}
- (void)loadUser:(NiteSiteButton *)sender
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@",sender.objectID]];
    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:userViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)closeAlerts:(id)sender {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRootController:YES];
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    if([_alertType isEqual:@"notification"]) {
        NotificationCell *cell = (NotificationCell *)[tableView cellForRowAtIndexPath:indexPath];
        if([cell.notificationType isEqual:@"follow_accept"] || [cell.notificationType isEqual:@"user_follow"]) {
            UserViewController *userViewController = [[UserViewController alloc]initWithSessionCookie:_sessionCookie userID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:userViewController];
            [menuController setRootController:navController animated:YES];
        }
        else if([cell.notificationType isEqual:@"party_invite"]) {
            PartyViewController *partyViewController = [[PartyViewController alloc] initWithSessionCookie:_sessionCookie partyID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:partyViewController];
            [menuController setRootController:navController animated:YES];
        }
        else if([cell.notificationType isEqual:@"shout_like"]) {
            ShoutViewController *shoutViewController = [[ShoutViewController alloc] initWithSessionCookie:_sessionCookie shoutID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:shoutViewController];
            [menuController setRootController:navController animated:YES];
        }
        else if([cell.notificationType isEqual:@"group_membership_accept"] || [cell.notificationType isEqual:@"party_invite"]) {
            GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:groupViewController];
            [menuController setRootController:navController animated:YES];
        }
    }
    else {
        RequestCell *cell = (RequestCell *)[tableView cellForRowAtIndexPath:indexPath];
        if([cell.requestType isEqual:@"group_invite"]) {
            GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:groupViewController];
            [menuController setRootController:navController animated:YES];
        }
        else if([cell.requestType isEqual:@"user_follow"]) {
            UserViewController *userViewController = [[UserViewController alloc]initWithSessionCookie:_sessionCookie userID:cell.referenceID];
            NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:userViewController];
            [menuController setRootController:navController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
