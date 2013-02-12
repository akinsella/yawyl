//
//  XBMasterViewController.h
//  Broadcast
//
//  Created by Alexis Kinsella on 28/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBDetailViewController;

#import <CoreData/CoreData.h>
#import "XBTableViewController.h"

@interface XBMasterViewController : XBTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate>

@property (strong, nonatomic) NSString* artist;

@end
