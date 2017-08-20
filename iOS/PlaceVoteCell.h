//
//  PlaceVoteCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/21/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceVoteCell : UICollectionViewCell
@property (nonatomic) NSString *placeID;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;

@end
