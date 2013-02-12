//
//  XBMasterViewController.m
//  Broadcast
//
//  Created by Alexis Kinsella on 28/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBMasterViewController.h"

#import "XBDetailViewController.h"
#import "UITableViewCell+VariableHeight.h"
#import "XBSongsHotttnesssCell.h"
#import "AFNetworking.h"
#import "XBAppDelegate.h"

@interface XBMasterViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation XBMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }

    [super awakeFromNib];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Hotttnesss";
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    [self fetchDataFromServerUsingBlock:^{}];
    [super viewDidLoad];
}

- (NSString *)baseUrl {
    return [XBAppDelegate baseUrl];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"SongsHotttnesss";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"XBSongsHotttnesssCell";
}

- (NSArray *)prepareDataSourceFromJSON:(id)JSON {
    NSDictionary *jsonDict = (NSDictionary *)JSON;
    return jsonDict[@"response"][@"songs"];
}

- (NSString *)resourcePath {
    return [NSString stringWithFormat:@"/xpua/song/search?sort=song_hotttnesss-desc&results=100&bucket=artist_familiarity&bucket=song_hotttnesss&artist=%@&limit=false", self.artist];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBSongsHotttnesssCell * ownerCell = (XBSongsHotttnesssCell *) cell;

    NSDictionary *item = [self objectAtIndex:(NSUInteger) indexPath.row];
    ownerCell.titleLabel.text = item[@"title"];
    ownerCell.descriptionLabel.text = item[@"artist_name"];
    ownerCell.identifier = item[@"id"];

    // @"http://blog.xebia.fr/wp-content/glc_cache/7ddf465686fcd2f34bdbfdd01915132b-60.jpg"]
    [ownerCell.imageView setImage: self.defaultAvatarImage];
/*
    [ownerCell.imageView setImageWithURL:[NSURL URLWithString: @"http://blog.xebia.fr/wp-content/glc_cache/7ddf465686fcd2f34bdbfdd01915132b-60.jpg"
                        placeholderImage:self.defaultAvatarImage];
*/
}

@end
