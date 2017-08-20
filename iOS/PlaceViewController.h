//
//  PlaceViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface PlaceViewController : UIViewController
@property (nonatomic) NSString *placeID;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *placeDict;
@property (nonatomic) NSString *relation;
- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID;

@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;

// Profile Head
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

// Action Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
- (void)alterActionButton;
- (IBAction)loadAction:(id)sender;

// Attending Users
@property (weak, nonatomic) IBOutlet NiteSiteButton *attendingUsersButton;
@property (weak, nonatomic) IBOutlet UILabel *attendingUsersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage1;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage2;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage3;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage4;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage5;
@property (weak, nonatomic) IBOutlet UIImageView *attendingUserImage6;

- (IBAction)loadAttendingUsers:(id)sender;

// Top Attendees
@property (weak, nonatomic) IBOutlet NiteSiteButton *topAttendeesButton;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage1;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage2;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage3;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage4;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage5;
@property (weak, nonatomic) IBOutlet UIImageView *topAttendeeImage6;

- (IBAction)loadTopAttendees:(id)sender;

// Statistics
- (IBAction)loadStatistics:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *statisticsImageView;
@property (weak, nonatomic) IBOutlet NiteSiteButton *statisticsButton;


- (void)initializePlace;
- (void)updatePlace;
@end
