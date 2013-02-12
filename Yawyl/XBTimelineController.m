//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBArtistsController.h"
#import "XBArtistCell.h"
#import "XBTimelineController.h"
#import "XBTimelineCell.h"
#import "GravatarHelper.h"
#import "AFNetworking.h"

@interface XBTimelineController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation XBTimelineController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }

    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.title = @"Timeline";
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    [self fetchDataFromServerUsingBlock:^{}];
}

- (NSString *)baseUrl {
    return @"http://vast-escarpment-6214.herokuapp.com";
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"Timeline";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"XBTimelineCell";
}

- (NSArray *)prepareDataSourceFromJSON:(id)JSON {
    return JSON;
}

- (NSString *)resourcePath {
    return @"/timeline/events";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBTimelineCell * ownerCell = (XBTimelineCell *) cell;

    NSDictionary *item = [self objectAtIndex:(NSUInteger) indexPath.row];
    ownerCell.login.text = item[@"login"];
    ownerCell.postalCode.text = item[@"postalCode"];
    ownerCell.artist.text = item[@"artist"];

    [GravatarHelper getGravatarURL:item[@"login"]];

    [ownerCell.imageView setImageWithURL:[GravatarHelper getGravatarURL:item[@"login"]]
                        placeholderImage:self.defaultAvatarImage];

}

@end
