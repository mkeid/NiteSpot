//
//  AppDelegate.m
//  NiteSite
//
//  Created by Mohamed Eid on 6/4/13.
//  Copyright (c) 2013 Mohamed Eid. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "WelcomeViewController.h"
#import "AboutViewController.h"
#import "TutorialViewController.h"
#import "WelcomePendingViewController.h"
#import "SSKeychain.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "PlacesViewController.h"
#import "MenuViewController.h"
#import "AlertsViewController.h"
#import "NiteSiteNavigationController.h"
#import "NiteSiteButton.h"

#define BaseURLString @"https://www.nitesite.co"
#define BasePicURLString @""

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.menuController = nil;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
    
    NSArray *accountsArray = [SSKeychain accountsForService:@"NiteSite"];
    if(accountsArray == nil) {
        WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc]
                                                        initWithNibName:@"WelcomeViewController"
                                                        bundle:[NSBundle mainBundle]];
        AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
        DDMenuController *ddMenuViewController = [[DDMenuController alloc] initWithRootViewController:welcomeViewController];
        ddMenuViewController.leftViewController = aboutViewController;
        ddMenuViewController.rightViewController = tutorialViewController;
                
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ddMenuViewController];
        navController.navigationBar.hidden = YES;
        self.menuController = ddMenuViewController;
        self.window.rootViewController = navController;
    }
    else {
        // Retrieve stored account & password from keychain.
        NSDictionary *accountDict = (NSDictionary *)[accountsArray objectAtIndex:0];
        NSString *account = (NSString *)[accountDict objectForKey:@"acct"];
        NSData *passwordData = [SSKeychain passwordDataForService:@"NiteSite" account:account];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        // Attempt to sign in.
        NSString *urlString = [NSString stringWithFormat:@"%@/users/sign_in", BaseURLString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        //set headers
        NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>", account] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>", password] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //post
        [request setHTTPBody:postBody];
        
        //get response
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([result isEqual:@"SUCCESS"] || [result isEqual:@"SUCCESS: NO SCHOOLS"]) {
            NSArray* authToken = [NSHTTPCookie
                                  cookiesWithResponseHeaderFields:[urlResponse allHeaderFields]
                                  forURL:[NSURL URLWithString:BaseURLString]];
            self.sessionCookie = authToken;
            
            if ([result isEqual:@"SUCCESS"]) {
                PlacesViewController *placesViewController = [[PlacesViewController alloc] initWithSessionCookie:authToken];
                NiteSiteNavigationController *navController = [[NiteSiteNavigationController alloc] initWithRootViewController:placesViewController];
                
                MenuViewController *menuViewController = [[MenuViewController alloc] initWithSessionCookie:authToken];
                
                AlertsViewController *alertsViewController = [[AlertsViewController alloc] initWithSessionCookie:authToken];
                
                
                DDMenuController *ddMenuViewController = [[DDMenuController alloc] initWithRootViewController:navController];
                ddMenuViewController.leftViewController = menuViewController;
                ddMenuViewController.rightViewController = alertsViewController;
                self.menuController = ddMenuViewController;
                
                self.window.rootViewController = ddMenuViewController;
            }
            else if ([result isEqual:@"SUCCESS: NO SCHOOLS"]) {
                WelcomePendingViewController *welcomePendingViewController = [[WelcomePendingViewController alloc] initWithSessionCookie:authToken];
                
                DDMenuController *ddMenuViewController = [[DDMenuController alloc] initWithRootViewController:welcomePendingViewController];
                
                self.menuController = ddMenuViewController;
                self.window.rootViewController = ddMenuViewController;
            }
        }
        else {
            [SSKeychain deletePasswordForService:@"NiteSite" account:account];
            WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc]
                                                            initWithNibName:@"WelcomeViewController"
                                                            bundle:[NSBundle mainBundle]];
            AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
            DDMenuController *ddMenuViewController = [[DDMenuController alloc] initWithRootViewController:welcomeViewController];
            ddMenuViewController.leftViewController = aboutViewController;
            ddMenuViewController.rightViewController = tutorialViewController;
                        
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ddMenuViewController];
            navController.navigationBar.hidden = YES;
            self.menuController = ddMenuViewController;
            self.window.rootViewController = navController;
        }
    }
    [self.window makeKeyAndVisible];
    
    // Networking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NiteSite" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NiteSite.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/users/add_push_device", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString *deviceTokenEdit = [[[NSString stringWithFormat:@"%@",deviceToken] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    
    NSData *postBody = [[NSString stringWithFormat:@"<token>%@</token>", deviceTokenEdit] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset:utf-8"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    // Cookies
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookie];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        self.checkedForPush = YES;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog([NSString stringWithFormat:@"%@",error]);}];
    [operation start];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NiteSiteButton *alertsButton = [[NiteSiteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [alertsButton addTarget:self action:@selector(openAlerts) forControlEvents:UIControlEventTouchUpInside];
    
    DDMenuController *menuController = self.menuController;
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.sessionCookie];
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset:utf-8"];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/me/alert_count.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *alertsCountDict  = (NSDictionary *)JSON;
        NSString *notificationsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"notifications"]];
        NSString *requestsCount = [NSString stringWithFormat:@"%@",[alertsCountDict objectForKey:@"requests"]];
        int alertsCount = [notificationsCount intValue]+[requestsCount intValue];
        
        // Set Number of alerts in button.
        [alertsButton setTitle:[NSString stringWithFormat:@"%d", alertsCount] forState:UIControlStateNormal];
        
        // Set button style/image
        if(alertsCount == 0) {
            [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton1.png"] forState:UIControlStateNormal];
        }
        else {
            [alertsButton setBackgroundImage:[UIImage imageNamed:@"alertsButton2.png"] forState:UIControlStateNormal];
        }
        [alertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [alertsButton.titleLabel setFont:[UIFont fontWithName:@"Arial-Bold" size:18]];
        
        // Set number of alerts in controller
        AlertsViewController *alertsViewController = (AlertsViewController *)menuController.rightViewController;
        [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Notifications: %@", notificationsCount] forSegmentAtIndex:0];
        alertsViewController.notificationCount = [notificationsCount intValue];
        
        [alertsViewController.segmentedControl setTitle:[NSString stringWithFormat:@"Requests: %@", requestsCount] forSegmentAtIndex:1];
        alertsViewController.requestCount = [requestsCount intValue];
        
        alertsViewController.notificationCount = [notificationsCount intValue];
        alertsViewController.requestCount = [requestsCount intValue];
        
        NiteSiteNavigationController *navControler = (NiteSiteNavigationController *)self.menuController.rootViewController;
        NSArray *viewControllers = navControler.viewControllers;
        UIViewController *currentViewController = [viewControllers objectAtIndex:[viewControllers count]-1];
        
        currentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:alertsButton];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}
- (void)openAlerts
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}



@end
