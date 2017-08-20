//
//  SettingsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"
#import "WaitingIndicatorView.h"

@interface SettingsViewController : UIViewController
@property (nonatomic, strong) WaitingIndicatorView *waitingIndicatorView;
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameFirstTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameLastTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *changedPassword1TextField;
@property (weak, nonatomic) IBOutlet UITextField *changedPassword2TextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *signOutButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton1;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton2;
@property (nonatomic) NSDictionary *meDict;
- (IBAction)dismissKeyboardButton:(id)sender;
- (IBAction)openPhotos:(id)sender;
- (id)initWithSessionCookie:(NSArray *)cookie;
- (IBAction)askToSignOut:(id)sender;
- (void)signOut;
- (IBAction)saveSettings;
- (void)updateForm;
@end
