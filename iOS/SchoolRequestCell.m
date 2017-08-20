//
//  SchoolRequestCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolRequestCell.h"

@implementation SchoolRequestCell

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
    _emailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _schoolLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _schoolLabel.textColor = [UIColor darkGrayColor];
}

@end
