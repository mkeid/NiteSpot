//
//  NiteSiteNavigationController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/15/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "NiteSiteNavigationController.h"
#import "GroupsViewController.h"
#import "SchoolsViewController.h"
#import "UsersViewController.h"
#import "UIViewController+Utilities.h"
#import "DDMenuController.h"

@implementation NiteSiteNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // this will appear as the title in the navigation bar
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
