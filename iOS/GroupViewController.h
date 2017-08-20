//
//  GroupViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupViewController : UIViewController <UINavigationControllerDelegate>
@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *groupID;
@property (nonatomic) NSString *groupPrivacy;
@property (nonatomic) NSDictionary *groupDict;
@property (nonatomic) NSString *relation;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
- (void)initializeGroup;
- (void)updateGroup;
- (void)setUpScroll;

// Top part
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

// Action Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
- (IBAction)loadAction:(id)sender;
- (void)groupLeave;
- (void)groupDestroy;
- (void)askToLeaveGroup;
- (void)askToDestroyGroup;


// Members
@property (weak, nonatomic) IBOutlet NiteSiteButton *membersButton;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage1;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage2;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage3;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage4;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage5;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage6;


// Admins
@property (weak, nonatomic) IBOutlet NiteSiteButton *adminsButton;
@property (weak, nonatomic) IBOutlet UILabel *adminCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage1;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage2;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage3;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage4;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage5;
@property (weak, nonatomic) IBOutlet UIImageView *adminImage6;

// Top Partiers
@property (weak, nonatomic) IBOutlet NiteSiteButton *topPartiersButton;
@property (weak, nonatomic) IBOutlet UIImageView *topPartiersImageView;

// Parties
@property (weak, nonatomic) IBOutlet NiteSiteButton *partiesButton;
@property (weak, nonatomic) IBOutlet UILabel *partyCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage1;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage2;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage3;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage4;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage5;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage6;

// Statistics
@property (weak, nonatomic) IBOutlet NiteSiteButton *statisticsButton;
@property (weak, nonatomic) IBOutlet UIImageView *statisticsImageView;

// Shouts
@property (weak, nonatomic) IBOutlet NiteSiteButton *shoutsButton;
@property (weak, nonatomic) IBOutlet UIImageView *shoutsImageView;

// Button Functions
- (IBAction)loadMembers:(id)sender;
- (IBAction)loadAdmins:(id)sender;
- (IBAction)loadParties:(id)sender;
- (IBAction)loadTopPartiers:(id)sender;
- (IBAction)loadStatistics:(id)sender;
- (IBAction)loadShouts:(id)sender;

// Group Admin Stuff
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *requestsButton;
- (IBAction)loadRequests:(id)sender;
- (IBAction)loadInvite:(id)sender;
- (IBAction)loadThrowParty:(id)sender;
- (IBAction)loadSettings:(id)sender;


@end
