//
//  CabViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface CabViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *cabID;
@property (nonatomic) NSDictionary *cabDict;
@property (nonatomic) NSString *cabNumber;
@property (nonatomic) NSString *relation;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (id)initWithSessionCookie:(NSArray *)cookie cabID:(NSString *)cabID;
- (void)initializeCab;
- (void)updateCab;

// Action Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
- (IBAction)loadAction:(id)sender;
- (void)alterActionButton;

// Call Button
@property (weak, nonatomic) IBOutlet NiteSiteButton *callButton;
- (IBAction)call:(id)sender;

@end
