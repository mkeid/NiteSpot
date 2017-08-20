//
//  GroupTopPartiersViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/22/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTopPartiersViewController : UIViewController
@property (nonatomic) NSDictionary *usersDict;
@property (nonatomic) NSString *groupID;
@property (nonatomic) NSMutableArray *usersUsedArray;
@property (nonatomic) NSString *selectedYear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) NSArray *sessionCookie;
- (IBAction)selectYear:(id)sender;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
- (id)initWithSessionCookie:(NSArray *)cookie usersDict:(NSDictionary *)usersDict;
@end
