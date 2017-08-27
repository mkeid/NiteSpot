//
//  WelcomeViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "AppDelegate.h"

#import "WelcomeViewController.h"
#import "ForgotPasswordViewController.h"
#import "WelcomePendingViewController.h"
#import "UIViewController+Utilities.h"
#import "SignUpViewController.h"
#import "SettingsViewController.h"
#import "GroupsViewController.h"
#import "PlacesViewController.h"
#import "MenuViewController.h"
#import "AlertsViewController.h"
#import "NiteSiteNavigationController.h"
#import "DDMenuController.h"

// Frameworks
#import "AFNetworking.h"
#import "SSKeychain.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation WelcomeViewController
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize signInText = _signInText;
@synthesize passwordText = _passwordText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Welcome";
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self preferredStatusBarStyle];
    [_signInButton setStyle:@"blueStyle"];
    [_signUpButton setStyle:@"greenStyle"];
    [_backgroundButton setStyle:@"whiteStyle"];
    [_blackBGButton setStyle:@"blackBGStyle"];
    _blackBGButton.alpha = .5;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {
    if([_emailTextField.text length] > 0 && [_passwordTextField.text length] > 0) {
        _signInText = _emailTextField.text;
        _passwordText = _passwordTextField.text;
    }
    UIAlertView *errorAlert;
    if([_signInText length] > 0 && [_passwordText length] > 0) {
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>", _signInText] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>", _passwordText] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
      
        NSString *requestURLString = [NSString stringWithFormat:@"%@/users/sign_in", BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPBody:postBody];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        // Cookies
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            UIAlertView *errorAlert;
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([result isEqual:@"SUCCESS"] || [result isEqual:@"SUCCESS: NO SCHOOLS"]) {
                // Save Keychain
                [SSKeychain setPassword:_passwordText forService:@"NiteSite" account:_signInText];
                //
                NSArray* authToken = [NSHTTPCookie
                                      cookiesWithResponseHeaderFields:[[operation response] allHeaderFields]
                                      forURL:[NSURL URLWithString:BaseURLString]];
                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).sessionCookie = authToken;
                
                if ([result isEqual:@"SUCCESS"]) {
                    
                    PlacesViewController *placesViewController = [[PlacesViewController alloc] initWithSessionCookie:authToken];
                    
                    MenuViewController *menuViewController = [[MenuViewController alloc] initWithSessionCookie:authToken];
                    
                    AlertsViewController *alertsViewController = [[AlertsViewController alloc] initWithSessionCookie:authToken];
                    
                    
                    DDMenuController *ddMenuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
                    ddMenuController.leftViewController = menuViewController;
                    ddMenuController.rightViewController = alertsViewController;
                    NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:placesViewController];
                    [ddMenuController setRootController:navController animated:YES];
                }
                else if ([result isEqual:@"SUCCESS: NO SCHOOLS"]) {
                    WelcomePendingViewController *welcomePendingViewController = [[WelcomePendingViewController alloc] initWithSessionCookie:authToken];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomePendingViewController];
                    
                    DDMenuController *ddMenuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
                    ddMenuController.leftViewController = nil;
                    ddMenuController.rightViewController = nil;
                    [ddMenuController setRootController:navController animated:YES];
                }
            }
            else if ([result isEqual:@"SUCCESS: INACTIVE"]) {
                errorAlert = [[UIAlertView alloc]
                              initWithTitle:@"Your account has not yet been activated."
                              message:@"Click the confirmation link that was sent to your registered email address to activate your account."
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
                [errorAlert show];
            }
            else {
                errorAlert = [[UIAlertView alloc]
                              initWithTitle:@"Sign in error."
                              message:@"This email / password combination is incorrect."
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
                [errorAlert show];
            }
         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self alertServerError];
             NSLog([NSString stringWithFormat:@"%@",error]);
         }];
        [operation start];
    }
    else {
        errorAlert = [[UIAlertView alloc]
                      initWithTitle:@"Oops!"
                      message:@"You did not entirely fill out the form."
                      delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil];
        [errorAlert show];
    }
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.emailTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    if(theTextField == self.passwordTextField){
        [self signIn:nil];
    }
    return YES;
}


- (IBAction)signUpWillLoad:(id)sender {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:signUpViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:signUpViewController animated:YES];
}

- (IBAction)keyboardDismiss:(id)sender {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (IBAction)loadForgotPassword:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self presentViewController:forgotPasswordViewController animated:YES completion:nil];
}
@end
