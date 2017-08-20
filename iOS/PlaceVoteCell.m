//
//  PlaceVoteCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/21/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlaceVoteCell.h"

@implementation PlaceVoteCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
