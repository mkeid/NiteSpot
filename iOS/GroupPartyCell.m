//
//  GroupPartyCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/20/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupPartyCell.h"

@implementation GroupPartyCell

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
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    _locationTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _locationLabel.textColor = [UIColor darkGrayColor];
    
    _timeTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _timeLabel.textColor = [UIColor darkGrayColor];
}

@end
