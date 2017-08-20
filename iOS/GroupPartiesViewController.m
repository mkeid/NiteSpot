//
//  GroupPartiesViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/20/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupPartiesViewController.h"
#import "UIViewController+Utilities.h"
#import "GroupPartyCell.h"
#import "PartyViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupPartiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie partiesArray:(NSArray *)partiesArray {
    self = [super initWithNibName:@"GroupPartiesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.partiesArray = partiesArray;
        self.title = @"Parties";
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID {
    self = [super initWithNibName:@"GroupPartiesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.partiesArray = [NSArray array];
        self.schoolID = schoolID;
        self.title = @"Parties";
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID {
    self = [super initWithNibName:@"GroupPartiesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.partiesArray = [NSArray array];
        self.groupID = groupID;
        self.title = @"Parties";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    if(_groupID != nil) {
        [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/groups/%@/parties.json", BaseURLString,_groupID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else if(_schoolID != nil) {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/%@/parties.json", BaseURLString, _schoolID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _partiesArray  = (NSMutableArray *)JSON;
            [_tableView reloadData];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
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
    NSString *responseInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [responseInfo dataUsingEncoding:NSUTF8StringEncoding];
    _partiesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_partiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupPartyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupPartyCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupPartyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.partyID = [NSString stringWithFormat:@"%@",[[_partiesArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_partiesArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [cell.partyImageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];
    
    cell.nameLabel.text = [[_partiesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.locationLabel.text = [[_partiesArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    cell.timeLabel.text = [[_partiesArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    
    // Set default border radius.
    CALayer * layer = [cell.partyImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupPartyCell *cell = (GroupPartyCell *)[tableView cellForRowAtIndexPath:indexPath];
    PartyViewController *partyViewController = [[PartyViewController alloc] initWithSessionCookie:_sessionCookie partyID:[NSString stringWithFormat:@"%@", cell.partyID]];
    [self.navigationController pushViewController:partyViewController animated:YES];
}

@end
