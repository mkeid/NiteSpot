//
//  PartySettingsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/9/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface PartySettingsViewController : UIViewController
@property (nonatomic) int HTTPTag;
@property (nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;

@property (nonatomic) NSDictionary *partyDict;
@property (nonatomic) NSString *partyID;
@property (nonatomic) NSArray *sessionCookie;
- (id)initWithSessionCookie:(NSArray *)cookie partyDict:(NSDictionary *)partyDict;

// Navigationbar
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)closeModal:(id)sender;
- (IBAction)save:(id)sender;

// Party Details
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet NiteSiteButton *deleteButton;

// Privacy
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

// Time
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

// Resign Keyboard
- (IBAction)resignKeyboard:(id)sender;

// ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Destroy Party
- (IBAction)askToDestroyParty:(id)sender;
- (void)destroyParty;

@end
