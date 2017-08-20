//
//  SchoolPlacesViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolPlacesViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *placesArray;
@property (nonatomic) NSString *schoolID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID;
- (id)initWithSessionCookie:(NSArray *)cookie placesArray:(NSArray *)placesArray;
@end
