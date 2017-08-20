//
//  SchoolRequestCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@end
