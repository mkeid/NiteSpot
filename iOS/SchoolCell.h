//
//  SchoolCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/16/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolCell : UITableViewCell
@property (nonatomic) NSString *schoolHandle;
@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolStatusLabel;

@end
