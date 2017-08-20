//
//  PartiesViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/10/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PartiesViewController.h"
#import "UIViewController+Utilities.h"
#import "PartyViewController.h"
#import "PartyVoteCell.h"
#import "PartyResultCell.h"
#import "PartiesVoteHeaderView.h"
#import "PartiesResultHeaderView.h"
#import "WaitingIndicatorView.h"
#import "UIImageView+AFNetworking.h"

// Frameworks
#import <QuartzCore/CoreAnimation.h>

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""


@implementation PartiesViewController

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
    self = [super initWithNibName:@"PartiesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.title = @"Parties";
        self.partiesType = @"vote";
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
    NSString *partiesInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [partiesInfo dataUsingEncoding:NSUTF8StringEncoding];
    _partiesDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _partiesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_collectionView reloadData];
    
    if([_partiesArray count] == 0) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"As of right now there are no parties going on tonight."
                                   message:@"If you want to throw a party of your own for your friends and school, do so through one of your groups."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
        [errorAlert show];
    }
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
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PartyVoteCell" bundle:nil] forCellWithReuseIdentifier:@"PartyVoteCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PartiesVoteHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PartiesVoteHeaderView"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PartyResultCell" bundle:nil] forCellWithReuseIdentifier:@"PartyResultCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PartiesResultHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PartiesResultHeaderView"];
    
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
    [self loadParties];
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadParties
{
    [self.view addSubview:_waitingIndicatorView];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/parties/list.json", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)changeVote
{
    [self.view addSubview:_waitingIndicatorView];
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/parties/list.json?change_vote=true", BaseURLString] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (void)attendParty:(NSString *)partyID
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/parties/%@/attend",BaseURLString,partyID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"]) {
            [self loadParties];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}


// Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // _data is a class member variable that contains one array per section.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_partiesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *partyDict = _partiesArray[indexPath.row];
    if([[partyDict objectForKey:@"type"] isEqual:@"vote"]) {
        [_toolBar setHidden:YES];
        _partiesType = @"vote";
        PartyVoteCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PartyVoteCell" forIndexPath:indexPath];
        [cell.partyImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [partyDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];
        
        cell.nameLabel.text = [partyDict objectForKey:@"name"];
        
        cell.partyID = [partyDict objectForKey:@"id"];
        
        // Shadow & Border
        cell.layer.masksToBounds = NO;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        //cell.layer.contentsScale = [UIScreen mainScreen].scale;
        cell.layer.shadowOpacity = 0.50f;
        cell.layer.shadowRadius = 4.0f;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        //cell.layer.shouldRasterize = YES;
        
        return cell;
    }
    else if([[partyDict objectForKey:@"type"] isEqual:@"result"]) {
        [_toolBar setHidden:NO];
        _partiesType = @"result";
        PartyResultCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PartyResultCell" forIndexPath:indexPath];
        
        [cell.partyImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BasePicURLString, [partyDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"groupAvatar.png"]];
        
        cell.nameLabel.text = [partyDict objectForKey:@"name"];
        
        _votesDict = _partiesArray[indexPath.row];
        
        cell.partyID = [partyDict objectForKey:@"id"];
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
        cell.layer.masksToBounds = NO;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        //cell.layer.contentsScale = [UIScreen mainScreen].scale;
        cell.layer.shadowOpacity = 0.50f;
        cell.layer.shadowRadius = 4.0f;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        //cell.layer.shouldRasterize = YES;
        
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if([_partiesType isEqual:@"vote"]) {
            PartiesVoteHeaderView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PartiesVoteHeaderView" forIndexPath:indexPath];
            return collectionReusableView;
        }
        else if([_partiesType isEqual:@"result"]) {
            PartiesResultHeaderView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PartiesResultHeaderView" forIndexPath:indexPath];
            [collectionReusableView.actionButton addTarget:self action:@selector(changeVote) forControlEvents:UIControlEventTouchDown];
            [collectionReusableView.actionButton setStyle:@"darkGreyStyle"];
            [collectionReusableView.refreshButton addTarget:self action:@selector(loadParties) forControlEvents:UIControlEventTouchDown];
            [collectionReusableView.refreshButton setStyle:@"darkGreyStyle"];
            return collectionReusableView;
        }
    }
    else {
        return nil;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_partiesType isEqual:@"vote"]) {
        PartyVoteCell *cell = (PartyVoteCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self attendParty:cell.partyID];
    }
    else if([_partiesType isEqual:@"result"]) {
        PartyResultCell *cell = (PartyResultCell *)[collectionView cellForItemAtIndexPath:indexPath];
        PartyViewController *partyViewController = [[PartyViewController alloc] initWithSessionCookie:_sessionCookie partyID:cell.partyID];
        [self.navigationController pushViewController:partyViewController animated:YES];
    }
}


@end
