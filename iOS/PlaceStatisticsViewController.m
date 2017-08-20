//
//  PlaceStatisticsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/25/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "PlaceStatisticsViewController.h"
#import "UIViewController+Utilities.h"

#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@interface PlaceStatisticsViewController ()

@end

@implementation PlaceStatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie placeID:(NSString *)placeID{
    self = [super initWithNibName:@"PlaceStatisticsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.placeID = placeID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Statistics";
    [_scrollView setContentSize:CGSizeMake(320,603)];
    
    // Font
    _allMaleLabel.textColor = [UIColor whiteColor];
    _allFemaleLabel.textColor = [UIColor whiteColor];
    _allLabel.textColor = [UIColor whiteColor];
    
    _freshmenMaleLabel.textColor = [UIColor whiteColor];
    _freshmenFemaleLabel.textColor = [UIColor whiteColor];
    _freshmenLabel.textColor = [UIColor whiteColor];
    
    _sophomoresMaleLabel.textColor = [UIColor whiteColor];
    _sophomoresFemaleLabel.textColor = [UIColor whiteColor];
    _sophomoresLabel.textColor = [UIColor whiteColor];
    
    _juniorsMaleLabel.textColor = [UIColor whiteColor];
    _juniorsFemaleLabel.textColor = [UIColor whiteColor];
    _juniorsLabel.textColor = [UIColor whiteColor];
    
    _seniorsMaleLabel.textColor = [UIColor whiteColor];
    _seniorsFemaleLabel.textColor = [UIColor whiteColor];
    _seniorsLabel.textColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/places/%@/statistics.json", BaseURLString, _placeID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _statsDict  = (NSDictionary *)JSON;
        [self updateStatistics];
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

- (void)updateStatistics
{
    NSDictionary *attendanceDict = [_statsDict objectForKey:@"user_attendance"];
    
    // All
    NSDictionary *allDict = [attendanceDict objectForKey:@"all"];
    float allMaleCount = [[allDict objectForKey:@"male"] intValue];
    float allFemaleCount = [[allDict objectForKey:@"female"] intValue];
    float allTotalCount = [[allDict objectForKey:@"total"] intValue];
    if(allTotalCount != 0) {
        _allLabel.text = [NSString stringWithFormat:@"All (%d)", (int)allTotalCount];
        _allMaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((allMaleCount/allTotalCount)*100)];
        _allFemaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((allFemaleCount/allTotalCount)*100)];
        
        _allMaleLabel.frame = CGRectMake(_allMaleLabel.frame.origin.x,_allMaleLabel.frame.origin.y,(allMaleCount/allTotalCount)*280,30);
        _allFemaleLabel.frame = CGRectMake(_allFemaleLabel.frame.origin.x,_allFemaleLabel.frame.origin.y,(allFemaleCount/allTotalCount)*280,30);
    }
    else {
        _allLabel.text = @"All (0)";
        [_allMaleLabel setHidden:YES];
        [_allFemaleLabel setHidden:YES];
    }
    
    // Freshmen
    NSDictionary *freshmenDict = [attendanceDict objectForKey:@"freshmen"];
    float freshmenMaleCount = [[freshmenDict objectForKey:@"male"] intValue];
    float freshmenFemaleCount = [[freshmenDict objectForKey:@"female"] intValue];
    float freshmenTotalCount = [[freshmenDict objectForKey:@"total"] intValue];
    if(freshmenTotalCount != 0) {
        _freshmenLabel.text = [NSString stringWithFormat:@"Freshmen (%d%%)", (int)((freshmenTotalCount/allTotalCount)*100)];
        _freshmenMaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((freshmenMaleCount/freshmenTotalCount)*100)];
        _freshmenFemaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((freshmenFemaleCount/freshmenTotalCount)*100)];
        
        _freshmenMaleLabel.frame = CGRectMake(_freshmenMaleLabel.frame.origin.x,_freshmenMaleLabel.frame.origin.y,(freshmenMaleCount/freshmenTotalCount)*280,30);
        _freshmenFemaleLabel.frame = CGRectMake(_freshmenFemaleLabel.frame.origin.x,_freshmenFemaleLabel.frame.origin.y,(freshmenFemaleCount/freshmenTotalCount)*280,30);
    }
    else {
        _freshmenLabel.text = @"Freshmen (0%)";
        [_freshmenMaleLabel setHidden:YES];
        [_freshmenFemaleLabel setHidden:YES];
    }
    
    // Sophomores
    NSDictionary *sophomoresDict = [attendanceDict objectForKey:@"sophomores"];
    float sophomoresMaleCount = [[sophomoresDict objectForKey:@"male"] intValue];
    float sophomoresFemaleCount = [[sophomoresDict objectForKey:@"female"] intValue];
    float sophomoresTotalCount = [[sophomoresDict objectForKey:@"total"] intValue];
    if(sophomoresTotalCount != 0) {
        _sophomoresLabel.text = [NSString stringWithFormat:@"Sophomores (%d%%)", (int)((sophomoresTotalCount/allTotalCount)*100)];
        _sophomoresMaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((sophomoresMaleCount/sophomoresTotalCount)*100)];
        _sophomoresFemaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((sophomoresFemaleCount/sophomoresTotalCount)*100)];
        
        _sophomoresMaleLabel.frame = CGRectMake(_sophomoresMaleLabel.frame.origin.x,_sophomoresMaleLabel.frame.origin.y,(sophomoresMaleCount/sophomoresTotalCount)*280,30);
        _sophomoresFemaleLabel.frame = CGRectMake(_sophomoresFemaleLabel.frame.origin.x,_sophomoresFemaleLabel.frame.origin.y,(sophomoresFemaleCount/sophomoresTotalCount)*280,30);
    }
    else {
        _sophomoresLabel.text = @"Sophomores (0%)";
        [_sophomoresMaleLabel setHidden:YES];
        [_sophomoresFemaleLabel setHidden:YES];
    }
    
    // Juniors
    NSDictionary *juniorsDict = [attendanceDict objectForKey:@"juniors"];
    float juniorsMaleCount = [[juniorsDict objectForKey:@"male"] intValue];
    float juniorsFemaleCount = [[juniorsDict objectForKey:@"female"] intValue];
    float juniorsTotalCount = [[juniorsDict objectForKey:@"total"] intValue];
    if(juniorsTotalCount != 0) {
        _juniorsLabel.text = [NSString stringWithFormat:@"Juniors (%d%%)", (int)((juniorsTotalCount/allTotalCount)*100)];
        _juniorsMaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((juniorsMaleCount/juniorsTotalCount)*100)];
        _juniorsFemaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((juniorsFemaleCount/juniorsTotalCount)*100)];
        
        _juniorsMaleLabel.frame = CGRectMake(_juniorsMaleLabel.frame.origin.x,_juniorsMaleLabel.frame.origin.y,(juniorsMaleCount/juniorsTotalCount)*280,30);
        _juniorsFemaleLabel.frame = CGRectMake(_juniorsFemaleLabel.frame.origin.x,_juniorsFemaleLabel.frame.origin.y,(juniorsFemaleCount/juniorsTotalCount)*280,30);
    }
    else {
        _juniorsLabel.text = @"Juniors (0%)";
        [_juniorsMaleLabel setHidden:YES];
        [_juniorsFemaleLabel setHidden:YES];
    }
    
    // Seniors
    NSDictionary *seniorsDict = [attendanceDict objectForKey:@"seniors"];
    float seniorsMaleCount = [[seniorsDict objectForKey:@"male"] intValue];
    float seniorsFemaleCount = [[seniorsDict objectForKey:@"female"] intValue];
    float seniorsTotalCount = [[seniorsDict objectForKey:@"total"] intValue];
    if(seniorsTotalCount != 0) {
        _seniorsLabel.text = [NSString stringWithFormat:@"Seniors (%d%%)", (int)((seniorsTotalCount/allTotalCount)*100)];
        _seniorsMaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((seniorsMaleCount/seniorsTotalCount)*100)];
        _seniorsFemaleLabel.text = [NSString stringWithFormat:@"%d%%", (int)((seniorsFemaleCount/seniorsTotalCount)*100)];
        
        _seniorsMaleLabel.frame = CGRectMake(_seniorsMaleLabel.frame.origin.x,_seniorsMaleLabel.frame.origin.y,(seniorsMaleCount/seniorsTotalCount)*280,30);
        _seniorsFemaleLabel.frame = CGRectMake(_seniorsFemaleLabel.frame.origin.x,_seniorsFemaleLabel.frame.origin.y,(seniorsFemaleCount/seniorsTotalCount)*280,30);
    }
    else {
        _seniorsLabel.text = @"Seniors (0%)";
        [_seniorsMaleLabel setHidden:YES];
        [_seniorsFemaleLabel setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
