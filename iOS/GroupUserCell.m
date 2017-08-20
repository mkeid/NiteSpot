//
//  GroupUserCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupUserCell.h"

@implementation GroupUserCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,5,40,40);
        
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _schoolLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _schoolLabel.textColor = [UIColor darkGrayColor];
}

@end
