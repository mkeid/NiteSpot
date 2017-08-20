//
//  InviteViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "InviteViewController.h"
#import "UIViewController+Utilities.h"
#import "SchoolRequestsViewController.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""


@implementation InviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie
{
    self = [super initWithNibName:@"InviteViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Invite";
    [_actionButton setStyle:@"blueStyle"];
    [_loadRequestsButton setStyle:@"greyStyle"];
    
    // Font
    _invitesRemainingLabel.textColor = [UIColor whiteColor];
    _invitesRemainingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    _invitesRemainingLabel.textAlignment = NSTextAlignmentCenter;
    
    [_whiteBGButton setStyle:@"whiteStyle"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateInviteCount];
    _invitesRemainingLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInviteCount
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/me/invite_count.json",BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       _invitesRemainingLabel.text = [NSString stringWithFormat:@"Invites Remaining: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        _invitesRemainingLabel.textAlignment = NSTextAlignmentCenter;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}

- (IBAction)resignKeyboard:(id)sender {
    [_emailTextField resignFirstResponder];
}

- (IBAction)inviteUser:(id)sender {
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>", _emailTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/schools/approve_requests",BaseURLString] body:postBody contentType:@"text/xml" cookiesToSend:_sessionCookie];
}

- (IBAction)loadSchoolRequests:(id)sender {
    SchoolRequestsViewController *schoolRequestsViewController = [[SchoolRequestsViewController alloc] initWithSessionCookie:_sessionCookie];
    [self presentViewController:schoolRequestsViewController animated:YES completion:nil];
}

// HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Oops!"
                               message:@"There was a server error."
                               delegate:nil
                               cancelButtonTitle:@"Ok."
                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    UIAlertView *inviteAlert;
    if ([[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
        [_emailTextField setText:@""];
        
        inviteAlert = [[UIAlertView alloc]
                       initWithTitle:@"Success"
                       message:@"Your friend is now on the network."
                       delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
        [inviteAlert show];
    }
    else {
        inviteAlert = [[UIAlertView alloc]
                       initWithTitle:@"Oops!"
                       message:@"Your friend is either already on the network or has not signed up yet."
                       delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
        [inviteAlert show];
    }
}
//

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == _emailTextField){
        [self inviteUser:nil];
    }
    return YES;
}
@end
