//
//  CabCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "CabCell.h"

@implementation CabCell

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
    _favoriteCountLabel.textColor = [UIColor whiteColor];
    _favoriteCountLabel.textAlignment = NSTextAlignmentCenter;
    _favoriteCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
}

@end
