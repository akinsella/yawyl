//
//  XBAppDelegate.m
//  Broadcast
//
//  Created by Alexis Kinsella on 28/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"
#import "AFHTTPRequestOperationLogger.h"
#import "SDURLCache.h"
#import "XBSharekitSupport.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

static NSString* const DeviceTokenKey = @"DeviceToken";

@interface XBAppDelegate ()
@end

@implementation XBAppDelegate

+(NSString *)baseUrl {
    return @"http://broadcast-mobile-backend.cloudfoundry.com";
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];


    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*2
                                                         diskCapacity:1024*1024*20
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:URLCache];


    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            [self processRemoteNotification:dictionary];
        }
    }

    [[NSUserDefaults standardUserDefaults] registerDefaults: @{ @"0" : DeviceTokenKey }];

    [XBSharekitSupport configure];


    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundRetro.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundRetroLandscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex: @"#BCBFB5"]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#962A06"],
            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:18.0f]
    }];
/*    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#5E6059"],
//            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
//            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:15.0f]
    } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#FFFFFF"],
//            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
//            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:15.0f]
    } forState:UIControlStateHighlighted];*/

//    [[UITableView appearance] setBackgroundColor:[UIColor colorWithHex:@"#F2F5E3"]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_fibers.png"]]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithHex:@"#BCBFB5"]];


//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//    }
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
    XBAppDelegate *appDelegate = (XBAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *viewController = [[appDelegate mainStoryBoard] instantiateViewControllerWithIdentifier:@"Root"];

    appDelegate.window.rootViewController = viewController;

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.

}

- (NSString*)udid {
    UIDevice* device = [UIDevice currentDevice];
    return [device.uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString*)deviceToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

- (void)setDeviceToken:(NSString*)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}

// Delegation methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);

    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"My token is: %@", newToken);

    if (self.deviceToken != newToken || !self.registered) {
        [self sendProviderDeviceToken: newToken];
        self.deviceToken = newToken;
        self.registered = YES;
    }


}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received notification: %@", userInfo);
    [self processRemoteNotification:userInfo];
}

- (void)sendProviderDeviceToken:(NSString *)deviceToken {
    NSDictionary *jsonPayload = @{ @"udid": [self udid], @"token": deviceToken};

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[XBAppDelegate baseUrl]]];
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:@"/api/notification/register" parameters:jsonPayload];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if (response.statusCode > 299) {
                                                                                                NSString *reasonPhrase = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine((__bridge CFHTTPMessageRef)response);
                                                                                                NSLog(@"We got an error ! Status code: %i - Message: %@", response.statusCode, reasonPhrase);
                                                                                            } else {
                                                                                                NSLog(@"Device was registered by server as expected");
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Device was registered by server as expected. Error: %@, JSON: %@", error, JSON);
                                                                                        }
    ];

    [operation start];

}

- (void)processRemoteNotification:(NSDictionary*)userInfo {
    NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];

    NSLog(@"Alert received: %@", alertValue);
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (UIStoryboard *)mainStoryBoard {

    NSString *storyBoardFilename = [NSString stringWithFormat:@"MainStoryboard_%@",
                    [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ?  @"iPad" : @"iPhone"];

    return [UIStoryboard storyboardWithName:storyBoardFilename bundle: nil];

}

- (UINavigationController *)rootNavigationController {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        return [splitViewController.viewControllers lastObject];
    }
    else{
        return (UINavigationController *)self.window.rootViewController;
    }
}

@end
