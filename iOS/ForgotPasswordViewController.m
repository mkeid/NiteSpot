//
//  ForgotPasswordViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/13/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"

@implementation ForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [_actionButton setStyle:@"blueStyle"];
    [_whiteBGButton setStyle:@"whiteStyle"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignKeyboard:(id)sender {
    [_textField resignFirstResponder];
}

- (IBAction)sendEmail:(id)sender {
    if(_textField.text.length > 5) {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/users/forgot_password", BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSData *postBody = [[NSString stringWithFormat:@"<email>%@</email>", _textField.text] dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postBody];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"Success"
                                   message:[NSString stringWithFormat:@"An email has been sent to %@ containing a link to reset your password.",_textField.text]
                                   delegate:nil
                                   cancelButtonTitle:@"Ok."
                                   otherButtonTitles:nil];
             [alert show];
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         }
         ];
        [operation start];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oops!"
                              message:[NSString stringWithFormat:@"That is not a valid email address."]
                              delegate:nil
                              cancelButtonTitle:@"Ok."
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [self sendEmail:nil];
    return YES;
}
@end
