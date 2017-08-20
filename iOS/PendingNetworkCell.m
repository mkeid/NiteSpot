//
//  PendingNetworkCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/13/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PendingNetworkCell.h"

@implementation PendingNetworkCell

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
    _nameLabel.textColor = [UIColor colorWithRed:.588 green:.8157 blue:.2863 alpha:1];
}

@end
