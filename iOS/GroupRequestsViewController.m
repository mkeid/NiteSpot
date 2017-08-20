//
//  GroupRequestsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupRequestsViewController.h"
#import "AppDelegate.h"
#import "GroupViewController.h"
#import "UIViewController+Utilities.h"
#import "UserViewController.h"
#import "DDMenuController.h"
#import "NiteSiteNavigationController.h"
#import "RequestCell.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupRequestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID{
    self = [super initWithNibName:@"GroupRequestsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupID = groupID;
        self.resultsArray = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateRequests];
}

- (void)updateRequests
{
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/groups/%@/requests.json", BaseURLString, _groupID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *resultsInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [resultsInfo dataUsingEncoding:NSUTF8StringEncoding];
    _resultsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
}

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequestCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *alertDict = [_resultsArray objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[alertDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    [cell.imageView setClipsToBounds:YES];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
 
    cell.requestType = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"request_type"]];
    
    // Message Label
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *timeFont = [UIFont systemFontOfSize:10];
    UIColor *foregroundColor = [UIColor colorWithRed:.588 green:.8157 blue:.2863 alpha:1];
    UIColor *timeColor = [UIColor colorWithRed:.67 green:.67 blue:.67 alpha:1];
    UIColor *timeBGColor = [UIColor colorWithRed:.157 green:.157 blue:.157 alpha:1];
    NSString *nameText;
    NSString *regText;
    NSString *timeText;
    NSString *entireText;
    
    // Create the attributes
    NSDictionary *nameAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               boldFont, NSFontAttributeName,
                               foregroundColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    NSDictionary *timeAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               timeFont, NSFontAttributeName, timeColor, NSForegroundColorAttributeName, timeBGColor, NSBackgroundColorAttributeName, nil];
    
    nameText = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"name"]];
    timeText = [NSString stringWithFormat:@"%@" ,[alertDict objectForKey:@"time"]];
    cell.requestType = [NSString stringWithFormat:@"%@" ,[alertDict objectForKey:@"kind"]];
    if([cell.requestType isEqual:@"group_join"]) {
        regText = @" wants to join your group. ";
        cell.referenceID = [alertDict objectForKey:@"from_user"];
    }

    entireText = [NSString stringWithFormat:@"%@ %@ %@",nameText, regText, timeText];
    NSLog(entireText);
    NSMutableAttributedString *attributedNameText = [[NSMutableAttributedString alloc] initWithString:nameText attributes:nameAttrs];
    NSMutableAttributedString *attributedRegularText = [[NSMutableAttributedString alloc] initWithString:regText attributes:subAttrs];
    NSMutableAttributedString *attributedTimeText = [[NSMutableAttributedString alloc] initWithString:timeText attributes:timeAttrs];
    [attributedNameText appendAttributedString:attributedRegularText];
    [attributedNameText appendAttributedString:attributedTimeText];
    [cell.messageLabel setAttributedText:attributedNameText];
    
    // Avatar Button
    cell.avatarButton.objectID = (NSString *)[alertDict objectForKey:@"from_user"];
    [cell.avatarButton addTarget:self action:@selector(loadUser:) forControlEvents:UIControlEventTouchUpInside];
    
    // Accept / Deny Buttons
    cell.acceptButton.tag = indexPath.row;
    cell.acceptButton.objectID = [alertDict objectForKey:@"id"];
    [cell.acceptButton addTarget:self action:@selector(acceptRequest:)
                forControlEvents:UIControlEventTouchUpInside];
    
    cell.denyButton.tag = indexPath.row;
    cell.denyButton.objectID = [alertDict objectForKey:@"id"];
    [cell.denyButton addTarget:self action:@selector(denyRequest:)
                forControlEvents:UIControlEventTouchUpInside];
    
    // Set button styles.
    [cell.acceptButton setStyle:@"blueStyle"];
    [cell.denyButton setStyle:@"greenStyle"];
    
    // Set default border radius.
    CALayer * layer = [cell.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestCell *cell = (RequestCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([cell.requestType isEqual:@"group_join"]) {
        GroupViewController *groupViewController = (GroupViewController *)(self.presentingViewController);
        NSLog(@"%@",groupViewController);
        UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@",cell.referenceID]];
        [self dismissViewControllerAnimated:YES completion:^{
            [(UINavigationController *)groupViewController pushViewController:userViewController animated:YES];
        }];
    }

}

- (void)acceptRequest:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/requests/%@/accept", BaseURLString, sender.objectID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self updateRequests];
         
         UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"Success"
                               message:@"The request was accepted."
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

- (void)denyRequest:(NiteSiteButton *)sender
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/requests/%@/destroy", BaseURLString, sender.objectID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self updateRequests];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     }
     ];
    [operation start];
}

- (void)loadUser:(NiteSiteButton *)sender
{
    GroupViewController *groupViewController = (GroupViewController *)(self.presentingViewController);
    NSLog(@"%@",groupViewController);
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@",sender.objectID]];
    [self dismissViewControllerAnimated:YES completion:^{
        [(UINavigationController *)groupViewController pushViewController:userViewController animated:YES];
    }];
}



@end
