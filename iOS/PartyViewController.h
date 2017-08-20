//
//  PartyViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface PartyViewController : UIViewController
@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

@property (nonatomic) NSString *partyID;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *partyDict;
@property (nonatomic) NSString *relation;
- (id)initWithSessionCookie:(NSArray *)cookie partyID:(NSString *)partyID;
- (void)initializeParty;
- (void)updateParty;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Action Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
- (void)alterActionButton;
- (IBAction)loadAction:(id)sender;

// Profile Head
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *partyImageView;

// Attending Users
@property (weak, nonatomic) IBOutlet NiteSiteButton *attendingUsersButton;
@property (weak, nonatomic) IBOutlet UILabel *attendingUsersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage1;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage2;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage3;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage4;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage5;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage6;

- (IBAction)loadAttendingUsers:(id)sender;


// Host Group
@property (weak, nonatomic) IBOutlet UIImageView *hostGroupImageView;
@property (weak, nonatomic) IBOutlet UILabel *hostGroupLabel;
@property (weak, nonatomic) IBOutlet NiteSiteButton *hostGroupButton;

- (IBAction)loadHostGroup:(id)sender;

// Additional Information
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalDetailsLabel;

// Admin stuff
- (IBAction)loadInvite:(id)sender;
- (IBAction)loadSettings:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


@end
