//
//  RequestCell.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/27/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "RequestCell.h"
#import "NiteSiteButton.h"
#import "AFNetworking.h"


@implementation RequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.acceptButton setStyle:@"blueStyle"];
        [self.denyButton setStyle:@"greenStyle"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,50,50);
    self.messageLabel.frame = CGRectMake(68,10,190,28);
    _messageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:NO];
    // Configure the view for the selected state
}

@end
