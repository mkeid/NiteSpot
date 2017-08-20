//
//  MenuViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSDictionary *meDict;

- (id)initWithSessionCookie:(NSArray *)cookie;
- (IBAction)loadUser:(id)sender;

- (IBAction)loadSettings:(id)sender;
- (IBAction)loadSearch:(id)sender;
- (void)loadFeed;
- (void)loadPlaces;
- (void)loadParties;
- (void)loadCabs;
- (void)loadGroups;
- (void)loadSchools;
- (void)loadInvite;

- (void)updateMenu;
- (IBAction)closeMenu:(id)sender;
@end
