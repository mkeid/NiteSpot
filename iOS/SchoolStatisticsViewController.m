//
//  SchoolStatisticsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SchoolStatisticsViewController.h"

@interface SchoolStatisticsViewController ()

@end

@implementation SchoolStatisticsViewController

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
    self = [super initWithNibName:@"SchoolStatisticsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.schoolID = schoolID;
        self.title = @"Statistics";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
