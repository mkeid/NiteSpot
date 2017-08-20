//
//  CabsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/17/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CabsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *cabsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (id)initWithSessionCookie:(NSArray *)cookie;

@property (nonatomic) BOOL checkZeroFavorites;
@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

- (IBAction)selectCabs:(id)sender;
- (void)loadFavorites;
- (void)loadAll;
@end
