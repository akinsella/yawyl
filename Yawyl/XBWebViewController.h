//
//  XBWebViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 04/10/12.
//
//

#import <UIKit/UIKit.h>
#import "XBShareInfo.h"
#import "SDWebImageManagerDelegate.h"

@interface XBWebViewController : UIViewController<UIWebViewDelegate, SDWebImageManagerDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *json;
@property (nonatomic, retain) XBShareInfo *shareInfo;

+(void)openURL:(NSURL *)url withTitle:(NSString *)title;

+(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo:(XBShareInfo *)shareInfo;

+(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)object shareInfo: (XBShareInfo *)shareInfo;

@end
