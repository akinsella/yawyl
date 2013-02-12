//
//  XBLoginViewController.m
//  Yawyl
//
//  Created by Alexis Kinsella on 06/02/13.
//  Copyright (c) 2013 Xebia / CodeStory. All rights reserved.
//

#import "XBLoginViewController.h"
#import "UIColor+XBAdditions.h"
#import "Validation.h"
#import "XBAppDelegate.h"
#import "SVProgressHUD.h"

@interface XBLoginViewController ()
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UITextField* emailTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@end

@implementation XBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    BOOL isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect tableViewFrame = CGRectMake(
            screenFrame.origin.x + (screenFrame.size.width / (isIpad ? 4 : 20)),
            screenFrame.origin.y + (screenFrame.size.height / (isIpad ? 4 : 8)),
            (isIpad ? screenFrame.size.width / 2 : screenFrame.size.width * 18 / 20),
            320
    );

    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [tableView setAutoresizesSubviews:YES];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView = tableView;
    [self.tableView setScrollEnabled:NO];
//    [self.tableView.backgroundView setBackgroundColor:[UIColor colorWithRed:48/255.0 green:71/255.0 blue:133/255.0 alpha:1]];

    [self.view addSubview:self.tableView];



    // Update the user interface for the detail item.
    self.view.backgroundColor = [UIColor colorWithHex:@"#040404"];

    UIImage *buttonImage = [[UIImage imageNamed:@"tanButton.png"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [self.loginBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.loginBtn setTitleColor:[UIColor colorWithHex:@"#9B3200"] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHex:@"#902D01"] forState:UIControlStateHighlighted];
    [[self.loginBtn titleLabel] setFont:[UIFont fontWithName:@"Lobster" size:15.0]];
    
    [self.view bringSubviewToFront:self.loginBtn];
}

- (IBAction)onClickLoginBtn:(id)sender {

    if (self.emailTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"Veuillez renseigner votre email"];
    }
    else if (self.passwordTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"Veuillez renseigner votre mot de passe"];
    }
    else {
        XBAppDelegate *appDelegate = (XBAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *viewController = [[appDelegate mainStoryBoard] instantiateViewControllerWithIdentifier:@"MainTabBar"];
        
        appDelegate.window.rootViewController = viewController;
//        [[appDelegate rootNavigationController] pushViewController:viewController animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 0, cell.contentView.bounds.size.width - 27, cell.contentView.bounds.size.height)];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:UIReturnKeyGo];
    textField.delegate = self;

    [textField setFont:[UIFont fontWithName:@"Lobster" size:14.0]];

    if (indexPath.row == 0) {
        [textField setPlaceholder:@"Email"];
        [textField setSecureTextEntry:NO];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        self.emailTextField = textField;
//        [textField becomeFirstResponder];
    } else {
        [textField setPlaceholder:@"Password"];
        [textField setSecureTextEntry:YES];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        self.passwordTextField = textField;
    }
    [cell.contentView addSubview:textField];

    return cell;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
