//
//  UsersViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/17/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface UsersViewController : UIViewController <UITableViewDataSource>
@property (nonatomic) NSMutableArray *usersArray;
@property (nonatomic) NSMutableArray *usersUsedArray;
@property (nonatomic) NSString *selectedYear;
@property (nonatomic) BOOL isAdmin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *sessionCookie;
- (IBAction)selectYear:(id)sender;
- (id)initWithSessionCookie:(NSArray *)cookie usersArray:(NSArray *)usersArray title:(NSString *)title;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID isAdmin:(BOOL)isAdmin usersType:(NSString *)usersType;
- (id)initWithSessionCookie:(NSArray *)cookie partyID:(NSString *)partyID;
- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID;
- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID;
- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID usersType:(NSString *)usersType;
- (void)updateUsers;

@property (nonatomic) NSString *profileClass;
@property (nonatomic) NSString *profileID;
@property (nonatomic) NSString *usersType;

// Group Admin Stuff
- (void)kickUser:(NiteSiteButton *)sender;
- (void)promotekUser:(NiteSiteButton *)sender;
- (void)demoteUser:(NiteSiteButton *)sender;

@end
