//
//  CabViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "CabViewController.h"
#import "UIViewController+Utilities.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation CabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie cabID:(NSString *)cabID
{
    self = [super initWithNibName:@"CabViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.cabID = cabID;
        [self initializeCab];
    }
    return self;
}

- (void)initializeCab
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/cabs/%@.json", BaseURLString, _cabID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _cabDict  = (NSDictionary *)JSON;
        [self updateCab];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Oops!"
                                   message:@"There was a server error."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok."
                                   otherButtonTitles:nil];
        [errorAlert show];
    }];
    [operation start];
}

- (void)updateCab
{
    _nameLabel.text = [NSString stringWithFormat:@"%@",[_cabDict objectForKey:@"name"]];
    _cabNumber = [NSString stringWithFormat:@"%@",[_cabDict objectForKey:@"phone_number"]];
    _numberLabel.text = [NSString stringWithFormat:@"%@",_cabNumber];
    _favoriteCountLabel.text = [NSString stringWithFormat:@"%@",[_cabDict objectForKey:@"favorite_count"]];
    // Avatar Image View
    [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_cabDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"cabAvatar.png"]];

    _relation = [_cabDict objectForKey:@"relation"];
    [self alterActionButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Cab";
    [_callButton setStyle:@"greenStyle"];
    
    _scrollView.scrollEnabled = NO;
    
    // Font
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _nameLabel.text = @"";
    
    _phoneLabel.textColor = [UIColor lightGrayColor];
    _phoneLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _numberLabel.text = @"";
    
    _favoriteLabel.textColor = [UIColor lightGrayColor];
    _favoriteLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _favoriteCountLabel.textColor = [UIColor whiteColor];
    _favoriteCountLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _favoriteCountLabel.text = @"";
    
    // Set default border radius.
    CALayer * layer = [_imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self initializeCab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"] || _HTTPTag == 0) {
        if(_HTTPTag == 0) {
            NSString *responseInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            NSData *data = [responseInfo dataUsingEncoding:NSUTF8StringEncoding];
            _cabDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self updateCab];
        }
        else if(_HTTPTag == 1) { // favorite cab
            _relation = @"favored";
            [self initializeCab];
            [self alterActionButton];
        }
        else if(_HTTPTag == 2) { // unfavorite cab
            _relation = @"not_favored";
            [self initializeCab];
            [self alterActionButton];
        }
    }
}

- (void)alterActionButton
{
    if([_relation isEqual:@"favored"]) {
        [_actionButton setStyle:@"blueStyle"];
        [_actionButton setTitle:@"Favored" forState:UIControlStateNormal];
    }
    else if([_relation isEqual:@"not_favored"]) {
        [_actionButton setStyle:@"greyStyle"];
        [_actionButton setTitle:@"Favorite" forState:UIControlStateNormal];
    }
}

- (IBAction)call:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://:%@",_cabNumber]]];
}
- (IBAction)loadAction:(id)sender {
    if([_relation isEqual:@"favored"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        _HTTPTag = 2;
        [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/cabs/%@/unfavorite", BaseURLString, _cabID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else if([_relation isEqual:@"not_favored"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        _HTTPTag = 1;
        [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/cabs/%@/favorite", BaseURLString, _cabID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
}
@end
