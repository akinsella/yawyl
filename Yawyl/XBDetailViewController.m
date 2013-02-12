//
//  XBDetailViewController.m
//  Broadcast
//
//  Created by Alexis Kinsella on 28/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBDetailViewController.h"
#import "UIColor+XBAdditions.h"

@interface XBDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation XBDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    self.view.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];

    UIImage *buttonImage = [[UIImage imageNamed:@"tanButton.png"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [self.actionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.actionButton setTitleColor:[UIColor colorWithHex:@"#9B3200"] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor colorWithHex:@"#902D01"] forState:UIControlStateHighlighted];
    [[self.actionButton titleLabel] setFont:[UIFont fontWithName:@"Lobster" size:15.0]];

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[self view]setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_fibers.png"]]];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
