//
//  SettingsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+Utilities.h"
#import "DDMenuController.h"
#import "WelcomeViewController.h"
#import "AboutViewController.h"
#import "TutorialViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "SSKeychain.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie {
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.waitingIndicatorView = [[[NSBundle mainBundle] loadNibNamed:@"WaitingIndicatorView" owner:self options:nil] lastObject];
        [_waitingIndicatorView updateView];
    }
    return self;
}

- (IBAction)askToSignOut:(id)sender {
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Sign Out" message:@"Are you sure you want to sign out?" delegate: self cancelButtonTitle: @"No"  otherButtonTitles:@"Yes",nil];
    
    [updateAlert show];
}

- (void)signOut
{
    // Retrieve stored account & password from keychain.
    NSArray *accountsArray = [SSKeychain accountsForService:@"NiteSite"];
    NSDictionary *accountDict = (NSDictionary *)[accountsArray objectAtIndex:0];
    NSString *account = (NSString *)[accountDict objectForKey:@"acct"];
    [SSKeychain deletePasswordForService:@"NiteSite" account:account];
    
    // Remove session cookie.
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).sessionCookie = nil;
    
    // Default check for push notifications.
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).checkedForPush = NO;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/users/destroy_push_device", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    [operation start];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc]
                                                    initWithNibName:@"WelcomeViewController"
                                                    bundle:[NSBundle mainBundle]];
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
    DDMenuController *ddMenuViewController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    ddMenuViewController.leftViewController = aboutViewController;
    ddMenuViewController.rightViewController = tutorialViewController;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    navController.navigationBar.hidden = YES;
    [ddMenuViewController setRootController:navController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self signOut];
    }
}

- (void)updateForm {
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/me.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *meDict  = (NSDictionary *)JSON;
        
        _nameFirstTextField.text = [meDict objectForKey:@"name_first"];
        _nameLastTextField.text = [meDict objectForKey:@"name_last"];
        [_avatarButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString,[meDict objectForKey:@"avatar_location"]]]]] forState:UIControlStateNormal];
        
        if([[meDict objectForKey:@"gender"] isEqual:@"male"]) {
            [_genderSegmentedControl setSelectedSegmentIndex:0];
        }
        else if([[meDict objectForKey:@"gender"] isEqual:@"female"]) {
            [_genderSegmentedControl setSelectedSegmentIndex:1];
        }
        
        if([[meDict objectForKey:@"year"] isEqual:@"freshman"]) {
            [_yearSegmentedControl setSelectedSegmentIndex:0];
        }
        else if([[meDict objectForKey:@"year"] isEqual:@"sophomore"]) {
            [_yearSegmentedControl setSelectedSegmentIndex:1];
        }
        else if([[meDict objectForKey:@"year"] isEqual:@"junior"]) {
            [_yearSegmentedControl setSelectedSegmentIndex:2];
        }
        else if([[meDict objectForKey:@"year"] isEqual:@"senior"]) {
            [_yearSegmentedControl setSelectedSegmentIndex:3];
        }
        
        if([[meDict objectForKey:@"privacy"] isEqual:@"public"]) {
            [_privacySegmentedControl setSelectedSegmentIndex:0];
        }
        else if([[meDict objectForKey:@"privacy"] isEqual:@"private"]) {
            [_privacySegmentedControl setSelectedSegmentIndex:1];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self alertServerError];
    }];
    [operation start];
}

- (IBAction)dismissKeyboardButton:(id)sender {
    [_nameFirstTextField resignFirstResponder];
    [_nameLastTextField resignFirstResponder];
    [_currentPasswordTextField resignFirstResponder];
    [_changedPassword1TextField resignFirstResponder];
    [_changedPassword2TextField resignFirstResponder];
}

- (IBAction)openPhotos:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    _avatarImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Settings";
    [_scrollView setContentSize:CGSizeMake(320,685)];
    _scrollView.canCancelContentTouches = YES;
    
    [_whiteBGButton1 setStyle:@"whiteStyle"];
    [_whiteBGButton2 setStyle:@"whiteStyle"];
    [_actionButton setStyle:@"blueStyle"];
    [_signOutButton setStyle:@"greyStyle"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateForm];
    [_scrollView setContentSize:CGSizeMake(320,685)];
    [_signOutButton addTarget:self action:@selector(askToSignOut:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)saveSettings {
    [self.view addSubview:_waitingIndicatorView];
    NSString *userGender;
    switch(_genderSegmentedControl.selectedSegmentIndex) {
        case 0:
            userGender = @"male";
            break;
        case 1:
            userGender = @"female";
            break;
    }
    NSString *userYear;
    switch(_yearSegmentedControl.selectedSegmentIndex) {
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
    NSString *userPrivacy;
    switch(_privacySegmentedControl.selectedSegmentIndex) {
        case 0:
            userPrivacy = @"public";
            break;
        case 1:
            userPrivacy = @"private";
            break;
    }
    
    NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSMutableData *postBody = [NSMutableData data];
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    [_params setObject:[NSString stringWithFormat:@"%@", _nameFirstTextField.text] forKey:@"user[name_first]"];
    [_params setObject:[NSString stringWithFormat:@"%@", _nameLastTextField.text] forKey:@"user[name_last]"];
    [_params setObject:[NSString stringWithFormat:@"%@", userGender] forKey:@"user[gender]"];
    [_params setObject:[NSString stringWithFormat:@"%@", userYear] forKey:@"user[year]"];
    [_params setObject:[NSString stringWithFormat:@"%@", _currentPasswordTextField.text] forKey:@"user[password1]"];
    [_params setObject:[NSString stringWithFormat:@"%@", _changedPassword1TextField.text] forKey:@"user[password2]"];
    [_params setObject:[NSString stringWithFormat:@"%@", _changedPassword2TextField.text] forKey:@"user[password3]"];
    [_params setObject:[NSString stringWithFormat:@"%@", userPrivacy] forKey:@"user[privacy]"];
    for (NSString *param in _params) {
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSData *imageData = UIImageJPEGRepresentation(_avatarImage, 1.0);
    if (imageData) {
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"avatar.jpg\"\r\n", @"user[avatar]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:imageData];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/users/update",BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_waitingIndicatorView removeFromSuperview];
        UIAlertView *settingsAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Success"
                                      message:@"Your settings were saved."
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
        [settingsAlert show];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [_waitingIndicatorView removeFromSuperview];
                                         [self alertServerError];
                                     }];
    [operation start];
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.nameFirstTextField){
        [self.nameLastTextField becomeFirstResponder];
    }
    if(theTextField == self.nameLastTextField){
        [self.currentPasswordTextField becomeFirstResponder];
    }
    if(theTextField == self.currentPasswordTextField){
        [self.changedPassword1TextField becomeFirstResponder];
    }
    if(theTextField == self.changedPassword1TextField){
        [self.changedPassword2TextField becomeFirstResponder];
    }
    if(theTextField == self.changedPassword2TextField){
        [self.changedPassword2TextField resignFirstResponder];
    }
    return YES;
}

@end
