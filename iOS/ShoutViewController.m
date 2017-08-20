//
//  ShoutViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "ShoutViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "NiteSiteNavigationController.h"
#import "UIViewController+Utilities.h"
#import "UserViewController.h"
#import "GroupViewController.h"
#import "PlaceViewController.h"
#import "PartyViewController.h"
#import "UserShoutLikeCell.h"
#import "FeedViewController.h"

// Frameworks
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/CoreAnimation.h>

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation ShoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie shoutID:(NSString *)shoutID{
    self = [super initWithNibName:@"ShoutViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.sessionCookie = cookie;
        self.shoutID = shoutID;
        self.title = @"Shout";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shout";
    
    // Font
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor darkGrayColor];
    _referenceNameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _referenceNameLabel.textColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    _referenceNameLabel.textAlignment = NSTextAlignmentCenter;
    [_referenceNameLabel sizeToFit];
    _likesCountLabel.textColor = [UIColor darkGrayColor];
    
    // Layout
    _optionsView.frame = CGRectMake(0,72, 320, 40);
    
    // Set default border radius.
    CALayer * layer = [_imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self loadShout];
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

- (void)loadShout
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 0;
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/shouts/%@.json", BaseURLString, _shoutID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

// HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Oops!"
                               message:@"There was a server error."
                               delegate:nil
                               cancelButtonTitle:@"Ok."
                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *shoutInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [shoutInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSLog([[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
    if ([[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] isEqual:@"SUCCESS"] || _HTTPTag == 0 || _HTTPTag == 1){
        if(_HTTPTag == 0) {
            _shoutDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _usersLikedArray = [_shoutDict objectForKey:@"liked_users"];
            
            // Top
            
            [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[_shoutDict objectForKey:@"avatar_location"]]]];
            _timeLabel.text = [NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"time"]];
            _nameLabel.text = [NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"owner_name"]];
            _referenceNameLabel.text = [NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"reference_name"]];
            
            if(![[_shoutDict objectForKey:@"reference_name"] isKindOfClass:[NSNull class]]){
                _referenceNameLabel.text = [NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"reference_name"]];
            }
            else {
                _referenceNameLabel.text = [NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"reference_class"]];
            }
            
            // Like Button
            if([[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"is_liked"]] isEqual:@"1"]) {
                _isLiked = YES;
                [_likeButton setTitle:@"" forState:UIControlStateNormal];
                [_likeButton setBackgroundColor:[UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1]];
            }
            else {
                _isLiked = NO;
                [_likeButton setTitle:@"" forState:UIControlStateNormal];
            }
            
            // Delete Button
            if([[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"self_owned"]] isEqual:@"1"]) {
                _deleteImageView.image = [UIImage imageNamed:@"Editing-Delete-icon.png"];
                _deleteButton.hidden = NO;
                [_deleteButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                _deleteImageView.hidden = YES;
                _deleteButton.hidden = YES;
            }
            
            [self updateLikeCount];
            
            // Text attribute stuff
            const CGFloat fontSize = 15;
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
            UIFont *specialFont = [UIFont boldSystemFontOfSize:fontSize];
            UIColor *regularColor = [UIColor blackColor];
            UIColor *specialColor = [UIColor blackColor];//[UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
            // Create the attributes
            NSDictionary *regularAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          regularFont, NSFontAttributeName,
                                          regularColor, NSForegroundColorAttributeName, nil];
            NSDictionary *specialAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          specialFont, NSFontAttributeName,
                                          specialColor, NSForegroundColorAttributeName, nil];
            // Generate message based on shout type.
            NSMutableAttributedString *messageAttributedString;
            if([[_shoutDict objectForKey:@"kind"] isEqual:@"party_throw"]) {
                messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is throwing a party." attributes:regularAttrs];
            }
            else if([[_shoutDict objectForKey:@"kind"] isEqual:@"party_attendance"]) {
                messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is going out to " attributes:regularAttrs];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@'s ",[_shoutDict objectForKey:@"reference_name"]] attributes:specialAttrs]];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"party." attributes:regularAttrs]];
            }
            else if([[_shoutDict objectForKey:@"kind"] isEqual:@"place_attendance"]) {
                messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is going out to " attributes:regularAttrs];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",[_shoutDict objectForKey:@"reference_name"]] attributes:specialAttrs]];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"tonight." attributes:regularAttrs]];
            }
            else if([[_shoutDict objectForKey:@"kind"] isEqual:@"place_attendance_change"]) {
                messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is going out to " attributes:regularAttrs];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",[_shoutDict objectForKey:@"reference_name"]] attributes:specialAttrs]];
                [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"tonight." attributes:regularAttrs]];
            }
            else if([[_shoutDict objectForKey:@"kind"] isEqual:@"status"]) {
                messageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"status"]] attributes:regularAttrs];
            }
            
            [_messageLabel setAttributedText:messageAttributedString];
        }
        else if(_HTTPTag == 1) { // Update user likes table]
            _usersLikedArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self updateLikeCount];
        }
        else if(_HTTPTag == 2) { // Unlike shout
            [_likeButton setBackgroundColor:[UIColor clearColor]];
            [self updateUserLikesTable];
        }
        else if(_HTTPTag == 3) { // Like shout
            
            [_likeButton setBackgroundColor:[UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1]];
            [self updateUserLikesTable];
        }
        else if(_HTTPTag == 4) { // Delete shout
            if([self.navigationController.viewControllers count] == 1) {
                DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
                FeedViewController *feedViewController = [[FeedViewController alloc] initWithSessionCookie:_sessionCookie];
                NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:feedViewController];
                [menuController setRootController:navController animated:YES];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        [_tableView reloadData];
    }
}

- (void)updateLikeCount
{
    // Like Count
    if([_usersLikedArray count] != 1) {
        _likesCountLabel.text = [NSString stringWithFormat:@"%d likes",[_usersLikedArray count]];
    }
    else {
        _likesCountLabel.text = [NSString stringWithFormat:@"%d like",[_usersLikedArray count]];
    }
}

- (void)updateUserLikesTable
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 1;
    [self HTTPAsyncRequest:@"GET" url:[NSString stringWithFormat:@"%@/shouts/%@/liked_users.json", BaseURLString, _shoutID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

// Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_usersLikedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserShoutLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserShoutLikeCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserShoutLikeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *userLikedDict = [_usersLikedArray objectAtIndex:indexPath.row];
    cell.userID = [userLikedDict objectForKey:@"user_id"];
    
    // Text attribute stuff
    const CGFloat fontSize = 15;
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *specialFont = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *regularColor = [UIColor whiteColor];
    UIColor *specialColor = [UIColor colorWithRed:0.16862745098 green:0.59607843137 blue:0.82352941176 alpha:1];
    // Create the attributes
    NSDictionary *regularAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName,
                                  regularColor, NSForegroundColorAttributeName, nil];
    NSDictionary *specialAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  specialFont, NSFontAttributeName,
                                  specialColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *messageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [userLikedDict objectForKey:@"name"]] attributes:specialAttrs];
    [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" likes this." attributes:regularAttrs]];
    [cell.messageLabel setAttributedText:messageAttributedString];
    
    // Image
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BasePicURLString,[userLikedDict objectForKey:@"avatar_location"]]] placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserShoutLikeCell *userShoutLikeCell = (UserShoutLikeCell *)[tableView cellForRowAtIndexPath:indexPath];
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:userShoutLikeCell.userID];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:userViewController animated:YES];
}


- (IBAction)loadProfile:(id)sender {
    if([[_shoutDict objectForKey:@"owner_class"] isEqual:@"User"]) {
        UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"user_id"]]];
        [self.navigationController pushViewController:userViewController animated:YES];
    }
    else if([[_shoutDict objectForKey:@"owner_class"] isEqual:@"Group"]) {
        GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"group_id"]]];
        [self.navigationController pushViewController:groupViewController animated:YES];
    }
}
- (IBAction)deleteAction:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _HTTPTag = 4;
    [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/shouts/%@/hide", BaseURLString, _shoutID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
}

- (IBAction)likeAction:(id)sender {
    if(_isLiked) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        _isLiked = NO;
        _HTTPTag = 2;
        [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/shouts/%@/unlike", BaseURLString,_shoutID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
    else if(!_isLiked) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        _isLiked = YES;
        _HTTPTag = 3;
        [self HTTPAsyncRequest:@"POST" url:[NSString stringWithFormat:@"%@/shouts/%@/like", BaseURLString, _shoutID] body:nil contentType:@"application/json" cookiesToSend:_sessionCookie];
    }
}
- (IBAction)loadReferenceProfile:(id)sender {
    if([[_shoutDict objectForKey:@"reference_class"] isEqual:@"Group"]) {
        GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"referenced_group_id"]]];
        [self.navigationController pushViewController:groupViewController animated:YES];
    }
    else if([[_shoutDict objectForKey:@"reference_class"] isEqual:@"Party"]) {
        PartyViewController *partyViewController = [[PartyViewController alloc] initWithSessionCookie:_sessionCookie partyID:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"referenced_party_id"]]];
        [self.navigationController pushViewController:partyViewController animated:YES];
    }
    else if([[_shoutDict objectForKey:@"reference_class"] isEqual:@"Place"]) {
        PlaceViewController *placeViewController = [[PlaceViewController alloc] initWithSessionCookie:_sessionCookie placeID:[NSString stringWithFormat:@"%@",[_shoutDict objectForKey:@"referenced_place_id"]]];
        [self.navigationController pushViewController:placeViewController animated:YES];
    }
}
@end
