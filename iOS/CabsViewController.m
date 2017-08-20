//
//  CabsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/17/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "CabsViewController.h"
#import "UIViewController+Utilities.h"
#import "CabViewController.h"
#import "CabCell.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation CabsViewController

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
    self = [super initWithNibName:@"CabsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.checkZeroFavorites = NO;
    }
    return self;
}

- (IBAction)selectCabs:(id)sender {
    switch(_segmentedControl.selectedSegmentIndex) {
        case 0:
            [self loadFavorites];
            break;
        case 1:
            [self loadAll];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Cabs";
    [self loadFavorites];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFavorites
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    
    [_segmentedControl setSelectedSegmentIndex:0];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/cabs/favorites.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _cabsArray  = (NSMutableArray *)JSON;
        if([_cabsArray count] == 0 && !_checkZeroFavorites) {
            [self loadAll];
        }
        else {
            [_tableView reloadData];
        }
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

- (void)loadAll
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    
    [_segmentedControl setSelectedSegmentIndex:1];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/cabs/list.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _cabsArray  = (NSMutableArray *)JSON;
        [_tableView reloadData];
        _checkZeroFavorites = YES;
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

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cabsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CabCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CabCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.cabID = [[_cabsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
    cell.nameLabel.text = [[_cabsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%@",[[_cabsArray objectAtIndex:indexPath.row] objectForKey:@"favorite_count"]];
    
    // Set default border radius.
    CALayer * layer = [cell.favoriteCountLabel layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CabCell *cell = (CabCell *)[tableView cellForRowAtIndexPath:indexPath];
    CabViewController *cabViewController = [[CabViewController alloc] initWithSessionCookie:_sessionCookie cabID:cell.cabID];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:cabViewController animated:YES];
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
    _cabsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([_cabsArray count] == 0 && _HTTPTag == 0 && !_checkZeroFavorites) {
        _checkZeroFavorites = YES;
        [self loadAll];
    }
    else {
        [_tableView reloadData];
    }
}



@end
