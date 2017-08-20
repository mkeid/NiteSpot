//
//  ShoutCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "ShoutCell.h"

@implementation ShoutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,50,50);
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.timeLabel.textColor = [UIColor darkGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
