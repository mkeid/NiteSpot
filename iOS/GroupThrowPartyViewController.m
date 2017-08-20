//
//  GroupThrowPartyViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupThrowPartyViewController.h"
#import "UIViewController+Utilities.h"
#import "PartyViewController.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupThrowPartyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID{
    self = [super initWithNibName:@"GroupThrowPartyViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupID = groupID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,540);
    _scrollView.canCancelContentTouches = YES;
    [_whiteBGButton setStyle:@"whiteStyle"];
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,540);
    _scrollView.canCancelContentTouches = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)throwParty:(id)sender {
    if([_nameTextField.text length] > 0 && [_locationTextField.text length] > 0) {
        NSString *partyPrivacy;
        if(_privacySegmentedControl.selectedSegmentIndex == 0 ) {
            partyPrivacy = @"1";
        }
        else if(_privacySegmentedControl.selectedSegmentIndex == 1 ) {
            partyPrivacy = @"0";
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<party>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<group_id>%@</group_id>", _groupID] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<name>%@</name>", _nameTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<address>%@</address>", _locationTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        if(_detailsTextField.text.length > 0) {
            [postBody appendData:[[NSString stringWithFormat:@"<description>%@</description>", _detailsTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [postBody appendData:[[NSString stringWithFormat:@"<public>%@</public>", partyPrivacy] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<date>%@</date>", [NSString stringWithFormat:@"%@", [df stringFromDate:_pickerView.date]]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</party>"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *requestURLString = [NSString stringWithFormat: @"%@/parties", BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPBody:postBody];
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if([responseString isEqual:@"SUCCESS"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Success"
                                           message:@"You have successfully thrown a party for your group."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            else if([responseString isEqual:@"ERROR: MULTIPLE PARTIES"]) {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"OOPS!"
                                           message:@"You can't throw multiple parties on the same day."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            else if([responseString isEqual:@"ERROR: PAST PARTY"]) {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"OOPS!"
                                           message:@"You can't throw a party in the past."
                                           delegate:nil
                                           cancelButtonTitle:@"Ok."
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

- (IBAction)resignKeyboard:(id)sender {
    [_nameTextField resignFirstResponder];
    [_locationTextField resignFirstResponder];
    [_detailsTextField resignFirstResponder];
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == _nameTextField){
        [_locationTextField becomeFirstResponder];
    }
    if(theTextField == _locationTextField){
        [_detailsTextField becomeFirstResponder];
    }
    if(theTextField == _detailsTextField){
        [_detailsTextField resignFirstResponder];
    }
    return YES;
}

@end
