//
//  GroupCreateViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/28/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupCreateViewController.h"
#import "UIViewController+Utilities.h"
#import "GroupsViewController.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createGroup:(id)sender {
    if(_nameTextField.text.length >= 3) {
        NSString *groupPrivacy;
        switch(_privacySegmentedControl.selectedSegmentIndex) {
            case 0:
                groupPrivacy = @"public";
                break;
            case 1:
                groupPrivacy = @"private";
                break;
        }
        
        NSString *groupType = [_pickerViewArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
        
        NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
        NSMutableData *postBody = [NSMutableData data];
        
        // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:@"1.0" forKey:@"ver"];
        [_params setObject:@"en" forKey:@"lan"];
        [_params setObject:[NSString stringWithFormat:@"%@", _nameTextField.text] forKey:@"group[name]"];
        [_params setObject:[NSString stringWithFormat:@"%@", groupPrivacy] forKey:@"group[privacy]"];
        [_params setObject:[NSString stringWithFormat:@"%@", groupType] forKey:@"group[group_type]"];
        for (NSString *param in _params) {
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSData *imageData = UIImageJPEGRepresentation(_avatarImage, 1.0);
        if (imageData) {
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"avatar.jpg\"\r\n", @"group[avatar]"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:imageData];
            [postBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *requestURLString = [NSString stringWithFormat:@"%@/groups",BaseURLString];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPBody:postBody];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];
        // Cookies
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        [request setAllHTTPHeaderFields:headers];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self dismissViewControllerAnimated:YES completion:^{
                [(GroupsViewController *)self.presentingViewController updateOwnGroups];
            }];
            UIAlertView *settingsAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Success"
                                          message:@"Your group was successfully created."
                                          delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
            [settingsAlert show];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertServerError];
        }];
        [operation start];
    }
    else {
        UIAlertView *settingsAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Oops!"
                                      message:@"Your group name is too short."
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
        [settingsAlert show];
    }
}

- (IBAction)pickAvatar:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [_nameTextField resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _avatarImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
}

- (id)initWithSessionCookie:(NSArray *)cookie{
    self = [super initWithNibName:@"GroupCreateViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.pickerViewArray = [[NSArray alloc] initWithObjects:@"Fraternity", @"Off-Campus House", @"On-Campus House", @"Music Group", @"Sorority", @"Sports Team", @"Other", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [_whiteBGButton setStyle:@"whiteStyle"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerViewArray objectAtIndex:row];
}

// TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.nameTextField){
        [_nameTextField resignFirstResponder];
    }
    return YES;
}

@end
