//
//  InviteCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/1/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCell : UITableViewCell
@property (nonatomic) NSString *userID;
@property (nonatomic) BOOL isAvailable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
