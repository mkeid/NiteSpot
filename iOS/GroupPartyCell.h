//
//  GroupPartyCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/20/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPartyCell : UITableViewCell
@property (nonatomic) NSString *partyID;
@property (weak, nonatomic) IBOutlet UIImageView *partyImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
