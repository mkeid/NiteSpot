//
//  PlacesViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceViewController.h"
#import "PlaceVoteCell.h"
#import "PlacesVoteHeaderView.h"
#import "PlaceResultCell.h"
#import "PlacesResultHeaderView.h"
#import "UIViewController+Utilities.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "NiteSiteNavigationController.h"
#import "NiteSiteButton.h"
#import "WaitingIndicatorView.h"

// Frameworks
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import <QuartzCore/CoreAnimation.h>

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation PlacesViewController

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
    self = [super initWithNibName:@"PlacesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.title = @"Places";
        self.placesType = @"vote";
        self.year = @"all";
        self.waitingIndicatorView = [[[NSBundle mainBundle] loadNibNamed:@"WaitingIndicatorView" owner:self options:nil] lastObject];
        [_waitingIndicatorView updateView];
    }
    return self;
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
    [_waitingIndicatorView removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_waitingIndicatorView removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *placesInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [placesInfo dataUsingEncoding:NSUTF8StringEncoding];
    _placesDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _placesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_collectionView reloadData];
}

- (IBAction)switchView:(id)sender {
    switch(_yearSegmentedControl.selectedSegmentIndex) {
        case 0:
            _year = @"all";
            [_collectionView reloadData];
            break;
        case 1:
            _year = @"fr";
            [_collectionView reloadData];
            break;
        case 2:
            _year = @"so";
            [_collectionView reloadData];
            break;
        case 3:
            _year = @"jr";
            [_collectionView reloadData];
            break;
        case 4:
            _year = @"sr";
            [_collectionView reloadData];
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Places";
    
    // ToolBar
    //[_toolBar setBackgroundImage:[UIImage imageNamed:@"toolBar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PlaceVoteCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceVoteCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PlacesVoteHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlacesVoteHeaderView"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PlaceResultCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceResultCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PlacesResultHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlacesResultHeaderView"];
    
    if([_year isEqual:@"all"]) {
        _yearSegmentedControl.selectedSegmentIndex = 0;
    }
    else if([_year isEqual:@"fr"]) {
        _yearSegmentedControl.selectedSegmentIndex = 1;
    }
    else if([_year isEqual:@"so"]) {
        _yearSegmentedControl.selectedSegmentIndex = 2;
    }
    else if([_year isEqual:@"jr"]) {
        _yearSegmentedControl.selectedSegmentIndex = 3;
    }
    else if([_year isEqual:@"sr"]) {
        _yearSegmentedControl.selectedSegmentIndex = 4;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadPlaces];
    
    // Let the device know we want to receive push notifications
    if(!((AppDelegate*)[[UIApplication sharedApplication] delegate]).checkedForPush) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)loadPlaces
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    [self.view addSubview:_waitingIndicatorView];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/places/list.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_waitingIndicatorView removeFromSuperview];
        _placesArray = (NSArray *)JSON;
        [_collectionView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Oops!"
                                   message:@"There was a server error."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok."
                                   otherButtonTitles:nil];
        [errorAlert show];
        [_waitingIndicatorView removeFromSuperview];
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeVote
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    [self.view addSubview:_waitingIndicatorView];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/places/list.json?change_vote=true", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_waitingIndicatorView removeFromSuperview];
        _placesArray = (NSArray *)JSON;
        [_collectionView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Oops!"
                                   message:@"There was a server error."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok."
                                   otherButtonTitles:nil];
        [errorAlert show];
        [_waitingIndicatorView removeFromSuperview];
    }];
    [operation start];
}

- (void)attendPlace:(NSString *)placeID
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    [self.view addSubview:_waitingIndicatorView];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/places/%@/attend", BaseURLString, placeID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog([[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
         [self loadPlaces];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There was a server error." delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles:nil];
        [errorAlert show];
    }];
    [operation start];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

// Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // _data is a class member variable that contains one array per section.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_placesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *placeDict = _placesArray[indexPath.row];
    if([[placeDict objectForKey:@"type"] isEqual:@"vote"]) {
        [_toolBar setHidden:YES];
    _placesType = @"vote";
    PlaceVoteCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceVoteCell" forIndexPath:indexPath];
        [cell.placeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [placeDict objectForKey:@"avatar_location"]]]];
        cell.nameLabel.text = [placeDict objectForKey:@"name"];
        
        cell.placeID = [placeDict objectForKey:@"id"];
        
        // Shadow & Border
        //cell.layer.masksToBounds = NO;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        //cell.layer.contentsScale = [UIScreen mainScreen].scale;
        //cell.layer.shadowOpacity = 0.50f;
        //cell.layer.shadowRadius = 4.0f;
        //cell.layer.cornerRadius = 2.0f;
        //cell.layer.shadowOffset = CGSizeZero;
        //cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        //cell.layer.shouldRasterize = YES;
        
        return cell;
    }
    else if([[placeDict objectForKey:@"type"] isEqual:@"result"]) {
        [_toolBar setHidden:NO];
        _placesType = @"result";
        PlaceResultCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceResultCell" forIndexPath:indexPath];
        
        [cell.placeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [placeDict objectForKey:@"avatar_location"]]]];
        
        cell.nameLabel.text = [placeDict objectForKey:@"name"];
        
        _votesDict = _placesArray[indexPath.row];
        
        cell.placeID = [placeDict objectForKey:@"id"];
        if([_year isEqual:@"all"]) {
            _votesDict = [NSMutableDictionary dictionaryWithDictionary:[_votesDict objectForKey:@"votes_all"]];
        }
        else if([_year isEqual:@"fr"]) {
            _votesDict = [NSMutableDictionary dictionaryWithDictionary:[_votesDict objectForKey:@"votes_fr"]];
        }
        else if([_year isEqual:@"so"]) {
            _votesDict = [NSMutableDictionary dictionaryWithDictionary:[_votesDict objectForKey:@"votes_so"]];
        }
        else if([_year isEqual:@"jr"]) {
            _votesDict = [NSMutableDictionary dictionaryWithDictionary:[_votesDict objectForKey:@"votes_jr"]];
        }
        else if([_year isEqual:@"sr"]) {
            _votesDict = [NSMutableDictionary dictionaryWithDictionary:[_votesDict objectForKey:@"votes_sr"]];
        }
        cell.totalVotesLabel.text = [NSString stringWithFormat:@"%@",[_votesDict objectForKey:@"total"]];
        cell.maleVotesLabel.text = [NSString stringWithFormat:@"♂ %@",[_votesDict objectForKey:@"male"]];
        cell.femaleVotesLabel.text = [NSString stringWithFormat:@"♀ %@",[_votesDict objectForKey:@"female"]];
        
        // Shadow & Border
        //cell.layer.masksToBounds = NO;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        cell.layer.cornerRadius = 2.0f;
        //cell.layer.contentsScale = [UIScreen mainScreen].scale;
        //cell.layer.shadowOpacity = 0.50f;
        //cell.layer.shadowRadius = 4.0f;
        //cell.layer.shadowOffset = CGSizeZero;
        //cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        //cell.layer.shouldRasterize = YES;

        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        NSMutableDictionary *placeDict = _placesArray[indexPath.row];
       if([_placesType isEqual:@"vote"]) {
            PlacesVoteHeaderView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlacesVoteHeaderView" forIndexPath:indexPath];
            return collectionReusableView;
        }
        else if([[placeDict objectForKey:@"type"] isEqual:@"result"]) {
            PlacesResultHeaderView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlacesResultHeaderView" forIndexPath:indexPath];
            [collectionReusableView.actionButton addTarget:self action:@selector(changeVote) forControlEvents:UIControlEventTouchDown];
            [collectionReusableView.actionButton setStyle:@"darkGreyStyle"];
            [collectionReusableView.refreshButton addTarget:self action:@selector(loadPlaces) forControlEvents:UIControlEventTouchDown];
            [collectionReusableView.refreshButton setStyle:@"darkGreyStyle"];
            return collectionReusableView;
        }
    }
    else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_placesType isEqual:@"vote"]) {
        PlaceVoteCell *cell = (PlaceVoteCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self attendPlace:cell.placeID];
    }
    else if([_placesType isEqual:@"result"]) {
        PlaceResultCell *cell = (PlaceResultCell *)[collectionView cellForItemAtIndexPath:indexPath];
        PlaceViewController *placeViewController = [[PlaceViewController alloc] initWithSessionCookie:_sessionCookie placeID:cell.placeID];
        [self.navigationController pushViewController:placeViewController animated:YES];
    }
}


@end
