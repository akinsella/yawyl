//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewController.h"


@interface XBTimelineController : XBTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;

@end