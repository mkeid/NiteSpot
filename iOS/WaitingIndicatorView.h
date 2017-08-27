//
//  WaitingIndicatorView.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/30/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface WaitingIndicatorView : UIView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *indicatorBoxView;
- (void)updateView;
@end
