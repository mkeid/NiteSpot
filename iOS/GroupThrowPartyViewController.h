//
//  GroupThrowPartyViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupThrowPartyViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *groupID;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
- (IBAction)closeModal:(id)sender;
- (IBAction)throwParty:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;

- (IBAction)resignKeyboard:(id)sender;

@end
