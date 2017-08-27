//
//  UIViewController+Utilities.m
//  NiteSite
//
//  Created by Mohamed Eid on 6/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "UIViewController+Utilities.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "AlertsViewController.h"
#import "NiteSiteButton.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"

@implementation UIViewController (Utilities)

- (NSString *)HTTPRequest:(NSString *)method url:(NSString *)urlString body:(NSMutableData *)requestData contentType:(NSString *)contentType cookiesToSend:(NSArray *)authCookies
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    // Add session cookie.
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:authCookies];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:method];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    if(requestData != nil) {
        [request setHTTPBody: requestData];
    }
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:YES];
    
    
    NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
    NSLog(@"Response String: %@", result);
    NSLog(@"%@", urlString);
    return result;
}

- (NSString *)HTTPGETRequest:(NSString *)urlString body:(NSMutableData *)requestData cookiesToSend:
    (NSArray *)authCookies {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // Add session cookie.
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:authCookies];
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSHTTPURLResponse* urlResponse = nil;

	NSError *error = [[NSError alloc] init];
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];
    [mainQueue setMaxConcurrentOperationCount:5];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
    NSLog(@"%@", urlString);
    return result;
    
}

- (void)HTTPAsyncRequest:(NSString *)method url:(NSString *)urlString body:(NSMutableData *)requestData contentType:(NSString *)contentType cookiesToSend:(NSArray *)authCookies
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    // Add session cookie.
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:authCookies];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:method];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    if(requestData != nil) {
        [request setHTTPBody: requestData];
    }
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (NSDictionary *)loadMeData
{
    NSDictionary *dict = nil;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *filePath =[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"account.plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        dict =  [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return dict;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [self preferredStatusBarStyle];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    NSDictionary *alertsButtonAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor],
                                UITextAttributeTextColor,
                                [UIColor clearColor],
                                UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    if([self.navigationController.viewControllers count] == 1) {
        NiteSiteButton *menuButton = [[NiteSiteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [menuButton setImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [menuButton showsTouchWhenHighlighted];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    else {
        NiteSiteButton *menuButton = [[NiteSiteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [menuButton setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        menuButton.adjustsImageWhenHighlighted = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
    if([self respondsToSelector:@selector(sessionCookie)] &&![self.nibName isEqual: @"(null)"] && ![self.nibName isEqual: @"SignUpViewController"] && ![self.nibName isEqual: @"WelcomeViewController"] && ![self.nibName isEqual: @"MenuViewController"] && ![self.nibName isEqual: @"NiteSiteNavigationController"] && ![self.nibName isEqual:@"UIImagePickerController"]) {
        
        NiteSiteButton *alertsButton = [[NiteSiteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [alertsButton addTarget:self action:@selector(openAlerts) forControlEvents:UIControlEventTouchUpInside];
        
        // Initialize Button
        [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton1.png"] forState:UIControlStateNormal];
        [alertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [alertsButton.titleLabel setFont:[UIFont fontWithName:@"Arial-Bold" size:18]];
        [alertsButton setTitle:@"" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:alertsButton];
        
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.sessionCookie];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
        NSString *requestURLString = [NSString stringWithFormat:@"%@/me/alert_count.json", BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *alertsCountDict  = (NSDictionary *)JSON;
            NSString *notificationsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"notifications"]];
            NSString *requestsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"requests"]];
            int alertsCount = [notificationsCount intValue]+[requestsCount intValue];
            
            // Set Number of alerts in button.
            [alertsButton setTitle:[NSString stringWithFormat:@"%d", alertsCount] forState:UIControlStateNormal];
            
            // Set button style/image
            if(alertsCount == 0) {
                [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton1.png"] forState:UIControlStateNormal];
            }
            else {
                [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton2.png"] forState:UIControlStateNormal];
            }
            
            // Set number of alerts in controller
            AlertsViewController *alertsViewController = (AlertsViewController *)menuController.rightViewController;
            [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Notifications: %@", notificationsCount] forSegmentAtIndex:0];
            alertsViewController.notificationCount = [notificationsCount intValue];
            
            [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Requests: %@", requestsCount] forSegmentAtIndex:1];
            alertsViewController.requestCount = [requestsCount intValue];
            
            alertsViewController.notificationCount = [notificationsCount intValue];
            alertsViewController.requestCount = [requestsCount intValue];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:alertsButton];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
}
- (void)openMenu
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}
- (void)openAlerts
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}

- (void)alertServerError
{
    /*UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Oops!"
                               message:@"There was a server error."
                               delegate:nil
                               cancelButtonTitle:@"Ok."
                               otherButtonTitles:nil];
    [errorAlert show];*/
}

@end
