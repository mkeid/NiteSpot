//
//  UserStatisticsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/19/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStatisticsViewController : UIViewController
@property (nonatomic) NSArray *placesArray;
@property (nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID;
- (id)initWithSessionCookie:(NSArray *)cookie statsDict:(NSDictionary *)statsDict;
@end
