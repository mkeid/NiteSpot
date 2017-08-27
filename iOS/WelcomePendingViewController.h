//
//  WelcomePendingViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/12/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface WelcomePendingViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NiteSiteButton *refreshButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *signOutButton;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *schoolsArray;
- (IBAction)signOut:(id)sender;
- (IBAction)updateRequestsAction:(id)sender;
- (void)updateRequests;
- (id)initWithSessionCookie:(NSArray *)cookie;
@end
