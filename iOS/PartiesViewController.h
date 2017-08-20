//
//  PartiesViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingIndicatorView.h"

@interface PartiesViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic, strong) WaitingIndicatorView *waitingIndicatorView;
@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie;
- (void)initializeParties;
- (void)loadParties;
- (void)changeVote;
- (void)attendParty:(NSString *)partyID;

@property (nonatomic) NSString *partiesType;
@property (nonatomic) NSString *year;
@property (nonatomic) NSArray *partiesArray;
@property (nonatomic) NSDictionary *partiesDict;
@property (nonatomic) NSMutableDictionary *votesDict;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *yearSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)switchView:(id)sender;

@end
