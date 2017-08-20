//
//  ForgotPasswordViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 8/13/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface ForgotPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;
- (IBAction)resignKeyboard:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)closeModal:(id)sender;

@end
