//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewController.h"


@interface XBArtistsController : XBTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;

@property (nonatomic, retain) IBOutlet UILabel* login;

@end