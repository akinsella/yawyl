//
//  XBMapViewController.m
//  Broadcast
//
//  Created by Alexis Kinsella on 30/01/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBMapViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "XBMapLocation.h"

@interface XBMapViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation XBMapViewController

@synthesize mapView;

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
	self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
        // 1
        CLLocationCoordinate2D zoomLocation;
/*
        zoomLocation.latitude = 48.856578;
        zoomLocation.longitude= 2.351828;
*/

        zoomLocation.latitude = 39.281516;
        zoomLocation.longitude= -76.580806;


        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( zoomLocation,
                                                                            10 * METERS_PER_MILE,
                                                                            10 * METERS_PER_MILE );
        // 3
        [mapView setRegion:viewRegion animated:YES];

//        [self refreshData];
}

- (IBAction)refreshTapped:(id)sender {
    [self refreshData];
}

-(void)refreshData {
    // 1
    MKCoordinateRegion mapRegion = [mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;

    // 2
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString,
                                                centerLocation.latitude, centerLocation.longitude, 0.5 * METERS_PER_MILE];
    NSLog(@"Data formatted: %@", json);


    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://data.baltimorecity.gov/api"]];

    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"POST"
                                                           path:@"/views/INLINE/rows.json?method=index"
                                                     parameters:nil];

    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"JSON: %@", JSON);

                                                                                            [self plotCrimePositions:JSON];
                                                                                            [SVProgressHUD dismiss];
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            NSLog(@"Error: %@, JSON: %@", error, JSON);
                                                                                        }];

    [operation start];

}

// Add new method above refreshTapped
- (void)plotCrimePositions:(NSDictionary *)root {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }

    NSArray *data = [root objectForKey:@"data"];

    for (NSArray *row in data) {
        NSNumber *latitude = row[22][1];
        NSNumber *longitude = row[22][2];
        NSString *crimeDescription = row[18];
        NSString *address = row[14];

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        XBMapLocation *annotation = [[XBMapLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        [mapView addAnnotation:annotation];
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[XBMapLocation class]]) {

        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        } else {
            annotationView.annotation = annotation;
        }

        return annotationView;
    }

    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    XBMapLocation *location = (XBMapLocation*)view.annotation;

    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
