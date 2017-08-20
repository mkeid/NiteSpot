//
//  PlacesResultHeaderView.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/24/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface PlacesResultHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet NiteSiteButton *refreshButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
@end
