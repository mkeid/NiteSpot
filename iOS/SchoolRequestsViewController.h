//
//  SchoolRequestsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/24/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolRequestsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *invitesArray;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) NSMutableArray *selectedUsersArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *invitesRemainingLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *inviteButton;
@property (nonatomic) int inviteCount;
@property (nonatomic) int inviteTextCount;
- (id)initWithSessionCookie:(NSArray *)cookie;
- (IBAction)closeModal:(id)sender;
- (IBAction)invite:(id)sender;
//- (void)acceptRequest:(NSString *)userID;
- (void)updateInviteCount;
- (void)setInviteCount:(int)count;
- (void)refresh;
@end
