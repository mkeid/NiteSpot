//
//  SearchViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *resultsArray;
@property (nonatomic) NSString *searchClass;
@property (nonatomic) NSMutableData *responseData;

- (IBAction)search:(id)sender;

- (IBAction)resignKeyboard:(id)sender;
- (id)initWithSessionCookie:(NSArray *)cookie;
@end
