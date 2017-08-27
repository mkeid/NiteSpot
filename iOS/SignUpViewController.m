//
//  SignUpViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIViewController+Utilities.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""


@implementation SignUpViewController
@synthesize emailTextField, passwordTextField, nameFirstTextField, nameLastTextField, genderSegmentedControl, yearSegmentedControl;

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)registerUser
{
    [self.view addSubview:_waitingIndicatorView];
    UIAlertView *signUpAlert;
    if(emailTextField.text.length > 0 && passwordTextField.text.length > 0 && nameFirstTextField.text.length > 0 && nameLastTextField.text.length > 0) {
        if(passwordTextField.text.length >= 6) {
            NSString *userGender;
            switch(genderSegmentedControl.selectedSegmentIndex) {
                case 0:
                    userGender = @"male";
                    break;
                case 1:
                    userGender = @"female";
                    break;
            }
            NSString *userYear;
            switch(yearSegmentedControl.selectedSegmentIndex) {
                case 0:
                    userYear = @"freshman";
                    break;
                case 1:
                    userYear = @"sophomore";
                    break;
                case 2:
                    userYear = @"junior";
                    break;
                case 3:
                    userYear = @"senior";
                    break;
            }
            
            //create the body
            NSMutableData *postBody = [NSMutableData data];
            [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>", emailTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>", passwordTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<name_first>%@</name_first>", nameFirstTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<name_last>%@</name_last>", nameLastTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<gender>%@</gender>", userGender] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"<year>%@</year>", userYear] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *requestURLString = [NSString stringWithFormat:@"%@/users",BaseURLString];
            NSURL *url = [NSURL URLWithString:requestURLString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPBody:postBody];
            NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request setHTTPMethod:@"POST"];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [_waitingIndicatorView removeFromSuperview];
                NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([response isEqual:@"SUCCESS"]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        UIAlertView *signUpAlert = [[UIAlertView alloc]
                                                    initWithTitle:@"Thanks for signing up for NiteSite."
                                                    message:[NSString stringWithFormat:@"An email containing a confirmation link to start using your account has been sent to %@.", emailTextField.text]
                                                    delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
                        [signUpAlert show];
                    }];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }
                else if([response isEqual:@"ERROR: INVALID SCHOOL"]) {
                    UIAlertView *signUpAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Oops!"
                                   message:@"Your school has not yet been registered for NiteSite."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
                    [signUpAlert show];
                }
                else if([response isEqual:@"ERROR: USER ALREADY SIGNED UP"]) {
                    UIAlertView *signUpAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Oops!"
                                   message:@"Someone is already signed up with that email address. If this is your account and you have lost your previous activation email, another email has been sent."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
                    [signUpAlert show];
                }
                else {
                    [_waitingIndicatorView removeFromSuperview];
                    [self alertServerError];
                    NSLog([[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_waitingIndicatorView removeFromSuperview];
                [self alertServerError];
                //NSLog([NSString stringWithFormat:@"%@",error]);
            }];
            [operation start];
        }
        else {
            [_waitingIndicatorView removeFromSuperview];
            signUpAlert = [[UIAlertView alloc]
                           initWithTitle:@"Oops!"
                           message:@"Your password is too short."
                           delegate:nil
                           cancelButtonTitle:@"Ok"
                           otherButtonTitles:nil];
            [signUpAlert show];
        }
    }
    else {
        [_waitingIndicatorView removeFromSuperview];
        signUpAlert = [[UIAlertView alloc]
                       initWithTitle:@"Oops!"
                       message:@"You didn't fill out the entire form."
                       delegate:nil
                       cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
        [signUpAlert show];
    }
}

- (IBAction)keyboardDismiss:(id)sender {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [nameFirstTextField resignFirstResponder];
    [nameLastTextField resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Sign up";
        self.waitingIndicatorView = [[[NSBundle mainBundle] loadNibNamed:@"WaitingIndicatorView" owner:self options:nil] lastObject];
        [_waitingIndicatorView updateView];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    _scrollView.contentSize = CGSizeMake(320,504);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [_scrollView setContentSize:CGSizeMake(320, 504)];
    _scrollView.contentSize = CGSizeMake(320,504);
    _scrollView.canCancelContentTouches = YES;
    
    [_whiteBGButton setStyle:@"whiteStyle"];

    
    [_signUpButton setStyle:@"greenStyle"];
    [_signUpButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    [_scrollView setContentSize:CGSizeMake(320, 504)];
    _scrollView.contentSize = CGSizeMake(320,504);
    _scrollView.canCancelContentTouches = YES;
    [_signUpButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.emailTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    if(theTextField == self.passwordTextField){
        [self.nameFirstTextField becomeFirstResponder];
    }
    if(theTextField == self.nameFirstTextField){
        [self.nameLastTextField becomeFirstResponder];
    }
    if(theTextField == self.nameLastTextField){
        [self.nameLastTextField resignFirstResponder];
    }
    return YES;
}

@end
