//
//  PartyVoteCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/28/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyVoteCell : UICollectionViewCell
@property (nonatomic) NSString *partyID;
@property (weak, nonatomic) IBOutlet UIImageView *partyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
