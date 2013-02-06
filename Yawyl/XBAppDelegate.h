//
//  XBAppDelegate.h
//  Yawyl
//
//  Created by Alexis Kinsella on 06/02/13.
//  Copyright (c) 2013 Xebia / CodeStory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
