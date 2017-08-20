//
//  ShoutCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface ShoutCell : UITableViewCell

@property (nonatomic) NSString *shoutID;
@property (nonatomic) NSString *relation;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NiteSiteButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)layoutSubviews;
@end
