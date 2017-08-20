//
//  PlaceResultCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/21/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlaceResultCell.h"

@implementation PlaceResultCell

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
    _maleVotesLabel.textColor = [UIColor whiteColor];
    _maleVotesLabel.textAlignment = NSTextAlignmentCenter;
    _maleVotesLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    
    _femaleVotesLabel.textColor = [UIColor whiteColor];
    _femaleVotesLabel.textAlignment = NSTextAlignmentCenter;
    _femaleVotesLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    
    _totalVotesLabel.textColor = [UIColor whiteColor];
    _totalVotesLabel.textAlignment = NSTextAlignmentCenter;
    _totalVotesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    
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
