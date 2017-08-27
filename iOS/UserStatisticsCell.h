//
//  UserStatisticsCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/21/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStatisticsCell : UITableViewCell
@property (nonatomic) NSString *placeID;
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendanceCountLabel;

@end
