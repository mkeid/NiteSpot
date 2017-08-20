//
//  PartySettingsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/9/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PartySettingsViewController.h"
#import "UIViewController+Utilities.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "GroupsViewController.h"
#import "NiteSiteNavigationController.h"

#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation PartySettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie partyDict:(NSDictionary *)partyDict
{
    self = [super initWithNibName:@"PartySettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.partyDict = partyDict;
        self.partyID = (NSString *)[partyDict objectForKey:@"id"];
    }
    return self;
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    if([_nameTextField.text length] > 0 && [_locationTextField.text length] > 0) {
        NSString *partyPrivacy;
        if(_segmentedControl.selectedSegmentIndex == 0 ) {
            partyPrivacy = @"true";
        }
        else if(_segmentedControl.selectedSegmentIndex == 1 ) {
            partyPrivacy = @"false";
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<party>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<group_id>%@</group_id>", (NSString *)[_partyDict objectForKey:@"group_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<name>%@</name>", _nameTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<address>%@</address>", _locationTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<description>%@</description>", _descriptionTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<public>%@</public>", partyPrivacy] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<date>%@</date>", [NSString stringWithFormat:@"%@", [df stringFromDate:_pickerView.date]]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</party>"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *requestURLString = [NSString stringWithFormat:@"%@/parties/%@", BaseURLString, _partyID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:postBody];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if([responseString isEqual:@"SUCCESS"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Success"
                                           message:@"You have successfully saved the settings for your party."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            else if([responseString isEqual:@"ERROR: MULTIPLE PARTIES"]) {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"OOPS!"
                                           message:@"You can't have multiple parties on the same day."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            else if([responseString isEqual:@"ERROR: PAST PARTY"]) {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"OOPS!"
                                           message:@"You can't have a party in the past."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
        }];
        [operation start];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Incomplete form."
                                   message:@"You must at least give a name and location for your party."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok."
                                   otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,540);
    _scrollView.canCancelContentTouches = YES;
    
    // Update default settings
    _nameTextField.text = (NSString *)[_partyDict objectForKey:@"name"];
    _locationTextField.text = (NSString *)[_partyDict objectForKey:@"address"];
    if(![[_partyDict objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        _descriptionTextField.text = (NSString *)[_partyDict objectForKey:@"description"];
    }
    
    if([[NSString stringWithFormat:@"%@", [_partyDict objectForKey:@"public"]] isEqual:@"1"]) {
        _segmentedControl.selectedSegmentIndex = 0;
    }
    else {
        _segmentedControl.selectedSegmentIndex = 1;
    }
    NSLog([NSString stringWithFormat:@"%@",[_partyDict objectForKey:@"time"]]);
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [df dateFromString:(NSString *)[_partyDict objectForKey:@"time"]];
    [_pickerView setDate:date];
    [_whiteBGButton setStyle:@"whiteStyle"];
    [_deleteButton setStyle:@"redStyle"];
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,540);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignKeyboard:(id)sender {
    [_nameTextField resignFirstResponder];
    [_locationTextField resignFirstResponder];
    [_descriptionTextField resignFirstResponder];
}



// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == _nameTextField){
        [_locationTextField becomeFirstResponder];
    }
    if(theTextField == _locationTextField){
        [_descriptionTextField becomeFirstResponder];
    }
    if(theTextField == _descriptionTextField){
        [_descriptionTextField resignFirstResponder];
    }
    return YES;
}
- (IBAction)askToDestroyParty:(id)sender {
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Party Deletion" message: @"Do you really want to delete this party?" delegate: self cancelButtonTitle: @"Yes"  otherButtonTitles:@"No",nil];
    
    [updateAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self destroyParty];
    }
}

- (void)destroyParty {
    NSString *requestURLString = [NSString stringWithFormat:@"%@/parties/%@", BaseURLString, _partyID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismissViewControllerAnimated:YES completion:^{
            DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
            if([[(UINavigationController *)menuController.rootViewController viewControllers] count] > 1) {
                [(UINavigationController *)menuController.rootViewController popViewControllerAnimated:YES];
            }
            else {
                GroupsViewController *groupsViewController = [[GroupsViewController alloc] initWithSessionCookie:_sessionCookie userID:nil];
                NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:groupsViewController];
                [menuController setRootController:navController animated:YES];
            }
        }];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [operation start];
}
@end
