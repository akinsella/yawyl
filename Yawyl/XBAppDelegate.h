//
//  XBAppDelegate.h
//  Broadcast
//
//  Created by Alexis Kinsella on 28/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

+ (NSString *)baseUrl;

- (UIStoryboard *)mainStoryBoard;

@property(nonatomic, assign) Boolean registered;
@property(nonatomic, retain) NSString *deviceToken;
- (UINavigationController *)rootNavigationController;

@end
