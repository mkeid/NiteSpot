//
//  WelcomeViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@class DDMenuController;
@interface WelcomeViewController : UIViewController
@property (strong, nonatomic) DDMenuController *menuController;
@property (weak, nonatomic) IBOutlet NiteSiteButton *backgroundButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *blackBGButton;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSString *signInText;
@property (strong, nonatomic) NSString *passwordText;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)signIn:(id)sender;
- (IBAction)signUpWillLoad:(id)sender;
- (IBAction)keyboardDismiss:(id)sender;
- (IBAction)loadForgotPassword:(id)sender;

// Buttons
@property (weak, nonatomic) IBOutlet NiteSiteButton *signInButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *signUpButton;

@end
