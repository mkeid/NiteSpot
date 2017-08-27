//
//  UserViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface UserViewController : UIViewController
@property (nonatomic) NSString *userID;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *userDict;
@property (nonatomic) NSArray *userArray;
@property (nonatomic) NSString *userRelation;
@property (nonatomic) NSString *userPrivacy;
- (id)initWithSessionCookie:(NSArray *)cookie userID:(NSString *)userID;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet NiteSiteButton *relationButton;
@property (weak, nonatomic) IBOutlet UILabel *followsYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendingLabel;

@property (weak, nonatomic) IBOutlet NiteSiteButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage1;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage2;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage3;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage4;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage5;
@property (weak, nonatomic) IBOutlet UIImageView *followingImage6;


@property (weak, nonatomic) IBOutlet NiteSiteButton *followersButton;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage1;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage2;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage3;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage4;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage5;
@property (weak, nonatomic) IBOutlet UIImageView *followersImage6;


@property (weak, nonatomic) IBOutlet NiteSiteButton *groupsButton;
@property (weak, nonatomic) IBOutlet UILabel *groupsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage2;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage3;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage4;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage5;
@property (weak, nonatomic) IBOutlet UIImageView *groupsImage6;


@property (weak, nonatomic) IBOutlet NiteSiteButton *schoolsButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *statisticsButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *shoutsButton;
@property (weak, nonatomic) IBOutlet UIImageView *schoolsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statisticsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shoutsImageView;

- (void)initializeUser;
- (void)updateUser;
- (void)alterActionButton;
- (IBAction)loadAction:(id)sender;

// Action Button
- (void)userUnfollow;
- (void)askToUnfollow;

- (IBAction)loadSettings;
- (IBAction)loadFollowedUsers:(id)sender;
- (IBAction)loadFollowers:(id)sender;
- (IBAction)loadGroups:(id)sender;
- (IBAction)loadSchools:(id)sender;
- (IBAction)loadStatistics:(id)sender;
- (IBAction)loadShouts:(id)sender;

@end
