//
//  ShoutViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoutViewController : UIViewController
@property (nonatomic) int HTTPTag;

@property (nonatomic) NSDictionary *shoutDict;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSString *shoutID;
@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie shoutID:(NSString *)shoutID;

@property (nonatomic) bool isLiked;
@property (nonatomic) NSString *profileClass;
@property (nonatomic) NSString *referenceClass;

// Top
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)loadProfile:(id)sender;

// Middle
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *referenceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *referenceButton;
- (IBAction)deleteAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)loadReferenceProfile:(id)sender;
- (void)updateLikeCount;
- (void)updateUserLikesTable;

// Table
@property (nonatomic) NSArray *usersLikedArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)loadShout;

@end
