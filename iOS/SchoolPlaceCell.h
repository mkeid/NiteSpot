//
//  SchoolPlaceCell.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolPlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic) NSString *placeID;
@end
