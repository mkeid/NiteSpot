//
//  PlaceStatisticsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/25/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceStatisticsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *statsDict;
@property (nonatomic) NSString *placeID;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID;
- (void)updateStatistics;

// All
@property (weak, nonatomic) IBOutlet UILabel *allMaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allFemaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

// Freshmen
@property (weak, nonatomic) IBOutlet UILabel *freshmenMaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freshmenFemaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freshmenLabel;

// Sophomores
@property (weak, nonatomic) IBOutlet UILabel *sophomoresMaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sophomoresFemaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sophomoresLabel;

// Juniors
@property (weak, nonatomic) IBOutlet UILabel *juniorsMaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *juniorsFemaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *juniorsLabel;

// Seniors
@property (weak, nonatomic) IBOutlet UILabel *seniorsMaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seniorsFemaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seniorsLabel;

@end
