//
//  NiteSiteButton.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "NiteSiteButton.h"
#import <QuartzCore/CoreAnimation.h>

@implementation NiteSiteButton

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
- (void)setStyle:(NSString *)style
{
    // Set default title color.
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Set default border radius.
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    // Set specific styles.
    if([style isEqual:@"blueStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.16862745098 green:0.59607843137 blue:0.82352941176 alpha:1]];
    }
    else if([style isEqual:@"greenStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.54901960784 green:0.77647058823 blue:0.24705882352 alpha:1]];
    }
    else if([style isEqual:@"darkBlueStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.16470588235 green:0.21960784313 blue:0.24705882352 alpha:1]];
    }
    else if([style isEqual:@"greyStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    }
    else if([style isEqual:@"darkGreyStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.23529411764 green:0.23529411764 blue:0.23529411764 alpha:1]];
    }
    else if([style isEqual:@"pendingStyle"]) {
        [self setBackgroundImage:[UIImage imageNamed:@"actionClearButton.png"] forState:UIControlStateNormal];
    }
    else if([style isEqual:@"redStyle"]) {
        [self setBackgroundColor:[UIColor redColor]];
    }
    else if([style isEqual:@"whiteStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        [self setTitleColor:[UIColor colorWithRed:0.16862745098 green:0.59607843137 blue:0.82352941176 alpha:1] forState:UIControlStateNormal];
    }
    else if([style isEqual:@"blackBGStyle"]) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        [layer setCornerRadius:20.0];
    }
    else {
        [self setStyle:@"greyStyle"];
    }
}

@end
