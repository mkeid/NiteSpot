//
//  SchoolsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *schoolsArray;
@property (nonatomic) NSString *userID;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableData *responseData;

- (id)initWithSessionCookie:(NSArray *)cookie schoolsArray:(NSArray *)schoolsArray;
- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID;
@end
