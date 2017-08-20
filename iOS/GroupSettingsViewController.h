//
//  GroupSettingsViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupSettingsViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSString *groupID;
@property (nonatomic) NSDictionary *groupDict;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) NSArray *pickerViewArray;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;
- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID;
- (id)initWithSessionCookie:(NSArray *)cookie groupDict:(NSDictionary *)groupDict;
- (IBAction)saveGroup:(id)sender;
- (IBAction)closeModal:(id)sender;

@property (nonatomic) BOOL hasUpdatedForm;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
- (IBAction)pickAvatar:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)resignKeyboard:(id)sender;
- (void)updateGroup;

@end
