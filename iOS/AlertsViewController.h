//
//  AlertsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface AlertsViewController : UIViewController
@property (nonatomic) int HTTPTag;
@property (nonatomic) BOOL reachedBottom;
@property (nonatomic) BOOL loadedMaxAlerts;
@property (nonatomic) NSMutableData *responseData;

@property (nonatomic) BOOL hasFinishedLoading;

@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie;
@property (nonatomic) NSString *alertType;
@property (nonatomic) NSArray *alertsArray;

// Attributes
@property (nonatomic) NSDictionary *nameAttrs;
@property (nonatomic) NSDictionary *subAttrs;
@property (nonatomic) NSDictionary *timeAttrs;
@property (nonatomic) NSDictionary *uncheckedAttrs;
@property (nonatomic) NSString *nameText;
@property (nonatomic) NSString *regText;
@property (nonatomic) NSString *timeText;
@property (nonatomic) NSString *entireText;
- (void)initAttributes;

// Counts
@property (nonatomic) int notificationCount;
@property (nonatomic) int requestCount;

// NavigationBar
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)loadAlerts:(id)sender;

// Table
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Notifications
- (void)loadNotifications;
- (void)getNewNotifications;
- (void)getOldNotifications;
- (void)updateNotificationCount:(int)count;

// Requests
- (void)loadRequests;
- (void)getNewRequests;
- (void)getOldRequests;
- (void)acceptRequest:(NiteSiteButton *)sender;
- (void)denyRequest:(NiteSiteButton *)sender;
- (void)updaterequestCount:(int)count;

// Alerts
- (void)loadAlerts;
- (void)updateAlertCount;

// Loading profiles
- (void)loadGroup:(NiteSiteButton *)sender;
- (void)loadShout:(UIButton *)sender;
- (void)loadParty:(UIButton *)sender;
- (void)loadUser:(NiteSiteButton *)sender;

- (IBAction)closeAlerts:(id)sender;
@end
