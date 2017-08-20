//
//  GroupInviteViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupInviteViewController : UIViewController
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *usersToInviteArray;
@property (nonatomic) NSMutableArray *selectedUsersArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *groupID;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;

- (IBAction)inviteUsers:(id)sender;
- (IBAction)closeModal:(id)sender;
@end
