//
//  UserStatisticsCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/21/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UserStatisticsCell.h"

@implementation UserStatisticsCell

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

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    _kindLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _kindLabel.textColor = [UIColor darkGrayColor];
    
    _attendanceCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _attendanceCountLabel.textColor = [UIColor whiteColor];
    _attendanceCountLabel.textAlignment = NSTextAlignmentCenter;
}

@end
