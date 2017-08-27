//
//  SignUpViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"
#import "WaitingIndicatorView.h"

@interface SignUpViewController : UIViewController
@property (nonatomic, strong) WaitingIndicatorView *waitingIndicatorView;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameLastTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *yearSegmentedControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NiteSiteButton *signUpButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;

- (IBAction)closeModal:(id)sender;

- (IBAction)registerUser;
- (IBAction)keyboardDismiss:(id)sender;

@end
