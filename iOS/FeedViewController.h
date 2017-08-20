//
//  FeedViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "NiteSiteButton.h"

@interface FeedViewController : PullRefreshTableViewController
@property (nonatomic) int HTTPTag;
@property (nonatomic) BOOL reachedBottom;
@property (nonatomic) BOOL loadedMaxShouts;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *sourceURLString;

// Attributes
@property (nonatomic) NSDictionary *regularAttrs;
@property (nonatomic) NSDictionary *specialAttrs;
- (void)initAttributes;

- (id)initWithSessionCookie:(NSArray *)cookie;
- (id)initWithSessionCookie:(NSArray *)cookie profileClass:(NSString *)profileClass profileID:(NSString *)profileID;
- (void)updateShouts;
- (void)getNewShouts;

- (void)loadGroup:(NiteSiteButton *)sender;
- (void)loadUser:(NiteSiteButton *)sender;

@property (nonatomic) NSArray *shoutsArray;
@end
