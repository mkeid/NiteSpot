//
//  UserStatisticCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/22/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStatisticCell : UITableViewCell
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *userYear;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendanceCountLabel;

@end
