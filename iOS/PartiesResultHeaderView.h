//
//  PartiesResultHeaderView.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/28/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface PartiesResultHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *refreshButton;
@end
