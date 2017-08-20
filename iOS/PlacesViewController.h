//
//  PlacesViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingIndicatorView.h"

@interface PlacesViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic, strong) WaitingIndicatorView *waitingIndicatorView;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSDictionary *placesDict;
@property (nonatomic) NSArray *placesArray;
@property (nonatomic) NSMutableDictionary *votesDict;
@property (nonatomic) NSString *year; // the selected year: 'all', 'fr', 'so', 'jr', 'sr'
@property (nonatomic) NSString *placesType; // 'vote' or 'result'
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (id)initWithSessionCookie:(NSArray *)cookie;
- (IBAction)switchView:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)attendPlace:(NSString *)placeID;
- (void)changeVote;

@end
