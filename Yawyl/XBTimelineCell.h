//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface XBTimelineCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel* login;

@property (nonatomic, retain) IBOutlet UILabel* postalCode;

@property (nonatomic, retain) IBOutlet UILabel* artist;


@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (CGFloat)heightForCell;

@end