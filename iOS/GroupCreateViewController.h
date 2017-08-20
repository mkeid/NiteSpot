//
//  GroupCreateViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/28/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface GroupCreateViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSArray *pickerViewArray;
@property (nonatomic) UIImage *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;


- (IBAction)closeView:(id)sender;
- (IBAction)createGroup:(id)sender;
- (IBAction)pickAvatar:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (id)initWithSessionCookie:(NSArray *)cookie;
@end
