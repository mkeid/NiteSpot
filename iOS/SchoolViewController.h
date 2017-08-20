//
//  SchoolViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface SchoolViewController : UIViewController
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *schoolDict;
@property (nonatomic) NSString *schoolHandle;
@property (nonatomic) NSString *relation;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithSessionCookie:(NSArray *)cookie schoolHandle:(NSString *)schoolHandle;
- (void)updateSchool;
- (void)initializeSchool;


@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// Action Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
- (void)alterActionButton;
- (IBAction)loadAction:(id)sender;

// Groups
@property (weak, nonatomic) IBOutlet NiteSiteButton *groupsButton;
@property (weak, nonatomic) IBOutlet UILabel *groupsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage1;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage2;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage3;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage4;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage5;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage6;

// Parties
@property (weak, nonatomic) IBOutlet NiteSiteButton *partiesButton;
@property (weak, nonatomic) IBOutlet UILabel *partiesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage1;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage2;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage3;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage4;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage5;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage6;

// Places
@property (weak, nonatomic) IBOutlet NiteSiteButton *placesButton;
@property (weak, nonatomic) IBOutlet UILabel *placesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage1;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage2;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage3;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage4;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage5;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage6;

// Users
@property (weak, nonatomic) IBOutlet NiteSiteButton *usersButton;
@property (weak, nonatomic) IBOutlet UILabel *usersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage1;
@property (weak, nonatomic) IBOutlet UIImageView *userImage2;
@property (weak, nonatomic) IBOutlet UIImageView *userImage3;
@property (weak, nonatomic) IBOutlet UIImageView *userImage4;
@property (weak, nonatomic) IBOutlet UIImageView *userImage5;
@property (weak, nonatomic) IBOutlet UIImageView *userImage6;

// Statistics
@property (weak, nonatomic) IBOutlet NiteSiteButton *statisticsButton;


// Button Functions
- (IBAction)loadGroups:(id)sender;
- (IBAction)loadParties:(id)sender;
- (IBAction)loadPlaces:(id)sender;
- (IBAction)loadUsers:(id)sender;
- (IBAction)loadStatistics:(id)sender;

@end
