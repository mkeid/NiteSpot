//
//  GroupUserCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupUserCell : UITableViewCell
@property (nonatomic) NSString *userID;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet NiteSiteButton *kickButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *adminButton;

@end
