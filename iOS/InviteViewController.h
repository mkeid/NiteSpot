//
//  InviteViewController.h
//  NiteSite
//
//  Created by Mohamed Eid on 7/14/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiteSiteButton.h"

@interface InviteViewController : UIViewController
@property (nonatomic) NSArray *sessionCookie;
@property (nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UILabel *invitesRemainingLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet NiteSiteButton *actionButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *whiteBGButton;
@property (weak, nonatomic) IBOutlet NiteSiteButton *loadRequestsButton;
- (IBAction)resignKeyboard:(id)sender;
- (IBAction)inviteUser:(id)sender;
- (IBAction)loadSchoolRequests:(id)sender;
- (void)updateInviteCount;
- (id)initWithSessionCookie:(NSArray *)cookie;
@end
