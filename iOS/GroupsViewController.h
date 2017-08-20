//
//  GroupsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *groupsArray;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *schoolID;
@property (nonatomic) NSString *ownerClass;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithSessionCookie:(NSArray *)cookie groupsArray:(NSArray *)groupsArray;
- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID;
- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID;

- (void)updateOwnGroups;

@property (nonatomic) NSMutableData *responseData;

// Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *createGroupButton;
- (IBAction)loadCreateGroup:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
