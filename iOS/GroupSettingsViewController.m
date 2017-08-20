//
//  GroupSettingsViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/26/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "GroupSettingsViewController.h"
#import "UIViewController+Utilities.h"
#import "GroupViewController.h"

// Frameworks
#import "AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation GroupSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupID:(NSString *)groupID{
    self = [super initWithNibName:@"GroupSettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupID = groupID;
        self.hasUpdatedForm = NO;
        self.pickerViewArray = [[NSArray alloc] initWithObjects:@"Fraternity", @"Off-Campus House", @"On-Campus House", @"Music Group", @"Sorority", @"Sports Team", @"Other", nil];
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie groupDict:(NSDictionary *)groupDict{
    self = [super initWithNibName:@"GroupSettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.groupDict = groupDict;
        self.groupID = [NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"id"]];
        self.hasUpdatedForm = NO;
        self.pickerViewArray = [[NSArray alloc] initWithObjects:@"Fraternity", @"Off-Campus House", @"On-Campus House", @"Music Group", @"Sorority", @"Sports Team", @"Other", nil];
    }
    return self;
}

- (IBAction)saveGroup:(id)sender {
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
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@", BaseURLString, _groupID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *settingsAlert = [[UIAlertView alloc]
                         initWithTitle:@"Success"
                         message:@"Your group settings were saved."
                         delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil];
        [settingsAlert show];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_whiteBGButton setStyle:@"whiteStyle"];
    //[_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*if(!_hasUpdatedForm) {
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
        NSString *requestURLString = [NSString stringWithFormat:@"%@/groups/%@.json", BaseURLString, _groupID];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _groupDict  = (NSDictionary *)JSON;
            [self updateGroup];
            _hasUpdatedForm = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
     }*/
    [self updateGroup];
}

- (void)updateGroup
{
    _nameTextField.text = [_groupDict objectForKey:@"name"];
    
    if([[_groupDict objectForKey:@"privacy"] isEqual:@"public"]) {
        _privacySegmentedControl.selectedSegmentIndex = 0;
    }
    else if([[_groupDict objectForKey:@"privacy"] isEqual:@"private"]) {
        _privacySegmentedControl.selectedSegmentIndex = 1;
    }
    
    //[_avatarButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_groupDict objectForKey:@"avatar_location"]]]]] forState:UIControlStateNormal];
    [_avatarImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString, [_groupDict objectForKey:@"avatar_location"]]]]]];
    
    
    if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Fraternity"]) {
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Off-Campus House"]) {
        [_pickerView selectRow:1 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"On-Campus House"]) {
        [_pickerView selectRow:2 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Music Group"]) {
        [_pickerView selectRow:3 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Sorority"]) {
        [_pickerView selectRow:4 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Sports Team"]) {
        [_pickerView selectRow:5 inComponent:0 animated:YES];
    }
    else if([[NSString stringWithFormat:@"%@",[_groupDict objectForKey:@"type"]] isEqual:@"Other"]) {
        [_pickerView selectRow:6 inComponent:0 animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [(GroupViewController *)(self.presentingViewController) initializeGroup];
    }];
}

- (IBAction)pickAvatar:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _avatarImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
    [_avatarImageView setImage:_avatarImage];
}

- (IBAction)resignKeyboard:(id)sender {
    [_nameTextField resignFirstResponder];
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
