//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "UIColor+XBAdditions.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XBAppDelegate.h"
#import "UITableViewCell+VariableHeight.h"
#import "XBTableViewController.h"

@interface XBTableViewController ()
    @property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation XBTableViewController

- (id)init {
    self = [super init];

    if (self) {
        // Init code
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self fetchDataFromServerUsingBlock:^{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)fetchDataFromServerUsingBlock:(void (^)())callback {
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[self.delegate baseUrl]]];
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET" path:[self.delegate resourcePath] parameters:nil];

    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"JSON: %@", JSON);
            self.dataSource = [self.delegate prepareDataSourceFromJSON:JSON];
            [self.tableView reloadData];
            if (callback) {
                callback();
            }
            [SVProgressHUD dismiss];
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
            NSLog(@"Error: %@, JSON: %@", error, JSON);
            if (callback) {
                callback();
            }
        }
    ];

    [operation start];
}

- (NSMutableArray *)prepareDataSourceFromJSON:(id)o {
 return nil;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self.dataSource objectAtIndex:index];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = [UIColor colorWithHex:@"#111111"];

//    [self.tableView registerNib:[UINib nibWithNibName:[self.delegate cellNibName] bundle:nil] forCellReuseIdentifier:[self.delegate cellReuseIdentifier]];

    self.tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [self fetchDataFromServerUsingBlock:^{
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self.delegate cellReuseIdentifier]];

    if (!cell) {
        // fix for rdar://11549999 (registerNib… fails on iOS 5 if VoiceOver is enabled)
        cell = [[[NSBundle mainBundle] loadNibNamed:[self.delegate cellReuseIdentifier] owner:self options:nil] objectAtIndex:0];
    }

    [self.delegate configureCell:cell atIndex:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return [cell respondsToSelector:@selector(heightForCell)] ? [cell heightForCell] : self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(onSelectCell:forObject:withIndex:)]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

        [self.delegate onSelectCell:cell forObject:[self.dataSource objectAtIndex:(NSUInteger) indexPath.row] withIndex:indexPath];
    }
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end