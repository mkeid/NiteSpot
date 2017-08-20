//
//  PartyInviteViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/9/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyInviteViewController : UIViewController
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *usersToInviteArray;
@property (nonatomic) NSMutableArray *selectedUsersArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *partyID;
@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie partyID:(NSString *)partyID;

// NavigationBar
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)closeModal:(id)sender;
- (IBAction)invite:(id)sender;

@end
