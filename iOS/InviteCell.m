//
//  InviteCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/1/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "InviteCell.h"

@implementation InviteCell

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
    self.imageView.frame = CGRectMake(0,0,43,43);
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
