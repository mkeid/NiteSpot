//
//  GroupPartiesViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/20/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPartiesViewController : UIViewController
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *partiesArray;
@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *groupID;
@property (nonatomic) NSString *schoolID;
- (id)initWithSessionCookie:(NSArray *)cookie partiesArray:(NSArray *)partiesArray;
- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
@end
