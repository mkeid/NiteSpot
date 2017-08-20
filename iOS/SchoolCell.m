//
//  SchoolCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolCell.h"

@implementation SchoolCell

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
    _schoolNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _schoolStatusLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _schoolStatusLabel.textColor = [UIColor darkGrayColor];
}

@end
