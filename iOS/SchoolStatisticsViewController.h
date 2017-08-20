//
//  SchoolStatisticsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolStatisticsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *schoolID;
- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID;
@end
