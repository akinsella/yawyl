//
// Created by akinsella on 06/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBArtistsController.h"
#import "XBArtistCell.h"
#import "XBAppDelegate.h"
#import "XBMasterViewController.h"

@interface XBArtistsController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation XBArtistsController

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
    self.title = @"Artistes";
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    self.searchBar.delegate = self;
    [super viewDidLoad];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchDataFromServerUsingBlock:^{}];
    [self.view endEditing:YES];
}

- (NSString *)baseUrl {
    return [XBAppDelegate baseUrl];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"Artist";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"XBArtistCell";
}

- (NSArray *)prepareDataSourceFromJSON:(id)JSON {
    NSDictionary *jsonDict = (NSDictionary *)JSON;
    return jsonDict[@"response"][@"artists"];
}

- (NSString *)resourcePath {
    return [NSString stringWithFormat:@"/xpua/artist/search?format=json&name=%@&results=100", self.searchBar.text];
}


-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    XBAppDelegate *appDelegate = (XBAppDelegate *)[[UIApplication sharedApplication] delegate];

    XBMasterViewController *hotnessViewController = (XBMasterViewController *)[[appDelegate mainStoryBoard] instantiateViewControllerWithIdentifier:@"Hotttnesss"];
    [self.navigationController pushViewController:hotnessViewController animated:YES];
    NSDictionary *item = (NSDictionary *)object;
    hotnessViewController.artist = item[@"artist"];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBArtistCell * ownerCell = (XBArtistCell *) cell;

    NSDictionary *item = [self objectAtIndex:(NSUInteger) indexPath.row];
    ownerCell.artist.text = item[@"name"];
    ownerCell.identifier = item[@"id"];

    // @"http://blog.xebia.fr/wp-content/glc_cache/7ddf465686fcd2f34bdbfdd01915132b-60.jpg"]
    [ownerCell.imageView setImage: self.defaultAvatarImage];
/*
    [ownerCell.imageView setImageWithURL:[NSURL URLWithString: @"http://blog.xebia.fr/wp-content/glc_cache/7ddf465686fcd2f34bdbfdd01915132b-60.jpg"
                        placeholderImage:self.defaultAvatarImage];
*/

}

@end
