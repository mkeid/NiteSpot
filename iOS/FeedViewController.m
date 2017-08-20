//
//  FeedViewController.m
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "FeedViewController.h"
#import "UIViewController+Utilities.h"

#import "ShoutCell.h"
#import "UserViewController.h"
#import "ShoutViewController.h"
#import "UserViewController.h"
#import "GroupViewController.h"

// Frameworks
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie {
    self = [super initWithNibName:@"FeedViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"News Feed";
        self.shoutsArray = [NSArray array];
        self.sessionCookie = cookie;
        self.reachedBottom = NO;
        self.loadedMaxShouts = NO;
        self.sourceURLString = [NSString stringWithFormat:@"%@/shouts/list.json",BaseURLString];
    }
    [self initAttributes];
    return self;
}

- (id)initWithSessionCookie:(NSArray *)cookie profileClass:(NSString *)profileClass profileID:(NSString *)profileID {
    self = [super initWithNibName:@"FeedViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"%@ Feed", profileClass];
        self.shoutsArray = [NSArray array];
        self.sessionCookie = cookie;
        self.reachedBottom = NO;
        self.loadedMaxShouts = NO;
        
        if([profileClass isEqual:@"Group"]) {
            self.sourceURLString = [NSString stringWithFormat:@"%@/groups/%@/feed.json",BaseURLString,profileID];
        }
        else if([profileClass isEqual:@"User"]) {
            self.sourceURLString = [NSString stringWithFormat:@"%@/users/%@/feed.json",BaseURLString,profileID];
        }
    }
    [self initAttributes];
    return self;
}

- (void)initAttributes
{
    // Text attribute stuff
    const CGFloat fontSize = 15;
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *specialFont = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *regularColor = [UIColor blackColor];
    UIColor *specialColor = [UIColor colorWithRed:.1687 green:.596 blue:.824 alpha:1];
    // Create the attributes
    _regularAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName,
                                  regularColor, NSForegroundColorAttributeName, nil];
    _specialAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  specialFont, NSFontAttributeName,
                                  specialColor, NSForegroundColorAttributeName, nil];
}

- (void)updateShouts
{    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = _sourceURLString;
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _shoutsArray = (NSArray *)JSON;
        NSLog([NSString stringWithFormat:@"%@",_shoutsArray]);
        if([_shoutsArray count] < 50) {
            _loadedMaxShouts = YES;
        }
        [self.tableView reloadData];
        //[self stopLoading];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)getNewShouts
{
    if([_shoutsArray count] > 0) {
        NSDictionary *shoutDict = [_shoutsArray objectAtIndex:[_shoutsArray count]-1];
        
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
        NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
        NSString *requestURLString = [NSString stringWithFormat:@"%@?kind=new&created_at=%@", _sourceURLString, [shoutDict objectForKey:@"created_at"]];
        NSURL *url = [NSURL URLWithString:requestURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setAllHTTPHeaderFields:headers];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"GET"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _shoutsArray = (NSArray *)JSON;
            [self.tableView reloadData];
            [self stopLoading];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self alertServerError];
        }];
        [operation start];
    }
    else {
        [self stopLoading];
    }
}

- (void)getOldShouts
{
    _reachedBottom = YES;
    NSDictionary *shoutDict = [_shoutsArray objectAtIndex:0];
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = [NSString stringWithFormat:@"%@?kind=old&created_at=%@&count=%d", _sourceURLString, [shoutDict objectForKey:@"created_at"],[_shoutsArray count]];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if(([(NSArray *)JSON count]-[_shoutsArray count]) < 50) {
            _loadedMaxShouts = YES;
        }
        _shoutsArray = (NSArray *)JSON;
        [self.tableView reloadData];
        [self stopLoading];
        _reachedBottom = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self alertServerError];
    }];
    [operation start];
}

- (void)refresh {
    [self performSelector:@selector(getNewShouts) withObject:nil afterDelay:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if([_shoutsArray count]>= 50) {
    CGPoint offset = self.tableView.contentOffset;
        CGRect bounds = self.tableView.bounds;
        CGSize size = self.tableView.contentSize;
        UIEdgeInsets inset = self.tableView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        if(y > h - 1000 && !_reachedBottom && !_loadedMaxShouts) {
            NSLog(@"loading rows");
            [self getOldShouts];
        }
    }
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
    [self alertServerError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *shoutInfo = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [shoutInfo dataUsingEncoding:NSUTF8StringEncoding];
    if(_HTTPTag == 0) {
        _shoutsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if([_shoutsArray count] < 50) {
            _loadedMaxShouts = YES;
        }
        [self.tableView reloadData];
    }
    else if(_HTTPTag == 1 || _HTTPTag == 2) {
        if(_HTTPTag == 2) {
            _reachedBottom = NO;
            if([[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] count] <50) {
                _loadedMaxShouts = YES;
            }
        }
        _shoutsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.tableView reloadData];
        [self stopLoading];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateShouts];
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

// Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shoutsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutCell"];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoutCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //[cell layoutSubViews];
    
    cell.shoutID = [[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",BasePicURLString,[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"avatar_location"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.imageView setImageWithURL:imageURL];
    [cell.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"userAvatar.png"]];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString *message;
    if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"name"] isEqual:@"place_attendance"]) {
        message = [NSString stringWithFormat:@"is going to %@ tonight.", [[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"name"] isEqual:@"party_attendance"]) {
        message = [NSString stringWithFormat:@"is going to %@'s party tonight.", [[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"name"] isEqual:@"party_throw"]) {
        message = @"is throwing a party tonight";
    }
    else {
        message = @"";
    }
    
    // Set the time label
    cell.timeLabel.text = [[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    
    // Generate message based on shout type.
    NSMutableAttributedString *messageAttributedString;
    if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"party_throw"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is throwing a party." attributes:_regularAttrs];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"party_attendance"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is going out to " attributes:_regularAttrs];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@'s ",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]] attributes:_specialAttrs]];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"party." attributes:_regularAttrs]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"party_attendance_change"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"changed plans and now going out to " attributes:_regularAttrs];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@'s ",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]] attributes:_specialAttrs]];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"party." attributes:_regularAttrs]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"place_attendance"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"is going out to " attributes:_regularAttrs];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]] attributes:_specialAttrs]];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"tonight." attributes:_regularAttrs]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"place_attendance_change"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"changed plans and is now going out to " attributes:_regularAttrs];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"reference_name"]] attributes:_specialAttrs]];
        [messageAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"tonight." attributes:_regularAttrs]];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"kind"] isEqual:@"status"]) {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"status"]] attributes:_regularAttrs];
    }
    else {
        messageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"status"]] attributes:_regularAttrs];
    }
    [cell.messageLabel setAttributedText:messageAttributedString];
    
    // Avatar Button
    if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"owner_class"] isEqual:@"Group"]) {
        cell.avatarButton.objectID = [NSString stringWithFormat:@"%@",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"group_id"]];
        [cell.avatarButton addTarget:self action:@selector(loadGroup:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"owner_class"] isEqual:@"User"]) {
        cell.avatarButton.objectID = [NSString stringWithFormat:@"%@",[[_shoutsArray objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
        [cell.avatarButton addTarget:self action:@selector(loadUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Set default border radius.
    CALayer * layer = [cell.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    /*// Styling
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(cell.imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:cell.imageView.bounds
                                cornerRadius:4.0] addClip];
    // Draw your image
    [cell.imageView.image drawInRect:cell.imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();*/
    
    return cell;
}

// Height for cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoutCell *cell = (ShoutCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 75;//+cell.messageLabel.frame.size.height;
}

// Cell selection functions.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoutCell *cell = (ShoutCell *)[tableView cellForRowAtIndexPath:indexPath];
    ShoutViewController *shoutViewController = [[ShoutViewController alloc] initWithSessionCookie:_sessionCookie shoutID:cell.shoutID];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:shoutViewController animated:YES];
}

// Loading Profiles
- (void)loadGroup:(NiteSiteButton *)sender
{
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSessionCookie:_sessionCookie groupID:[NSString stringWithFormat:@"%@",sender.objectID]];
    [self.navigationController pushViewController:groupViewController animated:YES];
}
- (void)loadUser:(NiteSiteButton *)sender
{
    UserViewController *userViewController = [[UserViewController alloc] initWithSessionCookie:_sessionCookie userID:[NSString stringWithFormat:@"%@",sender.objectID]];
    [self.navigationController pushViewController:userViewController animated:YES];
}

@end
