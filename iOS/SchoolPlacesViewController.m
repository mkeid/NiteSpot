//
//  SchoolPlacesViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/23/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolPlacesViewController.h"
#import "UIViewController+Utilities.h"
#import "PlaceViewController.h"
#import "SchoolPlaceCell.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation SchoolPlacesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie schoolID:(NSString *)schoolID
{
    self = [super initWithNibName:@"SchoolPlacesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placesArray = [NSArray array];
        self.schoolID = schoolID;
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie placesArray:(NSArray *)placesArray
{
    self = [super initWithNibName:@"SchoolPlacesViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placesArray = placesArray;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Places";
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_schoolID != nil) {
        NSString *requestURLString = [NSString stringWithFormat:@"%@/schools/%@/places.json",BaseURLString, _schoolID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _placesArray  = (NSMutableArray *)JSON;
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

// Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolPlaceCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SchoolPlaceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.placeID = [[_placesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    cell.nameLabel.text = [[_placesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.typeLabel.text = [[_placesArray objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolPlaceCell *cell = (SchoolPlaceCell *)[tableView cellForRowAtIndexPath:indexPath];
    PlaceViewController *placeViewController = [[PlaceViewController alloc] initWithSessionCookie:_sessionCookie placeID:[NSString stringWithFormat:@"%@", cell.placeID]];
    [self.navigationController pushViewController:placeViewController animated:YES];
}

@end
