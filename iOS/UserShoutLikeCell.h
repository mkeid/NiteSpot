//
//  UserShoutLikeCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/30/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserShoutLikeCell : UITableViewCell
@property (nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
