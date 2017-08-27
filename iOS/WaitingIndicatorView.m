//
//  WaitingIndicatorView.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/30/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "WaitingIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WaitingIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateView
{
    self.indicatorBoxView.layer.cornerRadius = 10.0f;
    /*self.indicatorBoxView.layer.shadowOffset = CGSizeZero;
    self.indicatorBoxView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.indicatorBoxView.layer.shadowOpacity = 1;
    self.indicatorBoxView.layer.shadowRadius = 110;*/
}

@end
