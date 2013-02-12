//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface XBArtistCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *artist;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (CGFloat)heightForCell;

@end