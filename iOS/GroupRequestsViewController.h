//
//  GroupRequestsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupRequestsViewController : UIViewController
@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) NSString *groupID;
@property (nonatomic) NSArray *resultsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
- (IBAction)closeModal:(id)sender;
- (void)updateRequests;

- (void)acceptRequest:(NiteSiteButton *)sender;
- (void)denyRequest:(NiteSiteButton *)sender;
- (void)loadUser:(NiteSiteButton *)sender;
@end
