//
//  RequestCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface RequestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NiteSiteButton *avatarButton;
@property (nonatomic) NSString *requestID;
@property (nonatomic) NSString *profileID;
@property (nonatomic) NSString *referenceID;
@property (nonatomic) NSString *requestType;

@property (nonatomic) NSMutableData *responseData;

// Accept & Deny buttons
@property (weak, nonatomic) IBOutlet NiteSiteButton *acceptButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *denyButton;

@end
