//
//  SignInViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "SignInViewController.h"
#import "UIViewController+Utilities.h"
//#import "UITableViewCell+CellShadows.h"
#import "SignInCell.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (IBAction)signInAction
{
    [self signIn];
}

- (void)signIn
{
    

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Sign In";
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell = [[SignInCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"MainCell"];
        cell.signInTextField.delegate = (id) self;
    }
    switch(indexPath.row)
    {
        case 0:
            cell.signInTextField.tag = 1;
            cell.signInTextField.placeholder = @"Email";
            cell.signInTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.signInTextField.returnKeyType = UIReturnKeyNext;
            [cell.signInTextField becomeFirstResponder];
            break;
        case 1:
            cell.signInTextField.tag = 2;
            cell.signInTextField.placeholder = @"Password";
            cell.signInTextField.keyboardType = UIKeyboardTypeDefault;
            cell.signInTextField.returnKeyType = UIReturnKeyDone;
            break;
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *signInButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Sign In"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(signInAction)];
    self.navigationItem.rightBarButtonItem = signInButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.toolbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nitesitetoolbar.png"]];
}

- (void)resignKeyboard:(id)sender{
    NSLog(@"YAY");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch(textField.tag)
    {
        case 1:
            [textField resignFirstResponder];
            [[self.view viewWithTag:2] becomeFirstResponder];
            break;
        case 2:
            [self signIn];
            break;
    }
    return YES;
}


@end
