//
//  UIViewController+Utilities.h
//  NiteSite
//
//  Created by Mohamed Eid on 6/11/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)
@property (nonatomic) NSArray *sessionCookie;
- (NSString *)HTTPRequest:(NSString *)method url:(NSString *)url body:(NSMutableData *)body contentType:(NSString *)type cookiesToSend:(NSArray *)authCookies;
- (NSString *)HTTPGETRequest:(NSString *)url body:(NSMutableData *)body cookiesToSend:(NSArray *)authCookies;
- (void)HTTPAsyncRequest:(NSString *)method url:(NSString *)urlString body:(NSMutableData *)requestData contentType:(NSString *)contentType cookiesToSend:(NSArray *)authCookies;
- (NSDictionary *)loadMeData;
- (void)openMenu;
- (void)openAlerts;
- (void)backAction;
- (void)alertServerError;
@end
