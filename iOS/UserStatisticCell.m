//
//  UserStatisticCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/22/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UserStatisticCell.h"

@implementation UserStatisticCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:NO];
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    _schoolLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _schoolLabel.textColor = [UIColor darkGrayColor];
    
    _attendanceCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _attendanceCountLabel.textColor = [UIColor whiteColor];
    _attendanceCountLabel.textAlignment = NSTextAlignmentCenter;
}

@end
