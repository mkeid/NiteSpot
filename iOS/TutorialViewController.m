//
//  TutorialViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 8/15/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "NiteSiteNavigationController.h"
#import "WelcomeViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,1691);
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320,1691);
    _scrollView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0f];
    _scrollView.alpha=1;
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
