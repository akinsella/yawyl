//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBArtistCell.h"
#import <QUartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBConstants.h"
#import "XBTimelineCell.h"

@implementation XBTimelineCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (CGFloat)heightForCell {
    return 64;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:@"#333333"].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, rect.origin.x ,rect.origin.y); //start at this point
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y); //draw to this point
    CGContextStrokePath(context);


    context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:@"#111111"].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, rect.origin.x ,rect.origin.y + rect.size.height); //start at this point
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height); //draw to this point
    CGContextStrokePath(context);
}

@end