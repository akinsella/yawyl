//
//  XBLoginViewController.h
//  Yawyl
//
//  Created by Alexis Kinsella on 06/02/13.
//  Copyright (c) 2013 Xebia / CodeStory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)onClickLoginBtn:(id)sender;

@end
