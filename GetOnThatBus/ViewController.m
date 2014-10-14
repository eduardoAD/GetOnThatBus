//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Eduardo Alvarado Díaz on 10/14/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *stopArray;
@property MKPointAnnotation *busStopAnnotation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self obtainData];
}

- (void)obtainData{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *jsonError = nil;

        self.stopArray = [((NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]) objectForKey:@"row"];

        //NSLog(@"Connection error: %@", connectionError);
        //NSLog(@"JSON error: %@", jsonError);

        [self addAnnotations];
    }];
}

- (void)addAnnotations{
    for (NSDictionary *busStop in self.stopArray) {
        CLLocationCoordinate2D coord;
        coord.latitude = [[busStop objectForKey:@"latitude"] doubleValue];
        coord.longitude = [[busStop objectForKey:@"longitude"] doubleValue];

        self.busStopAnnotation = [[MKPointAnnotation alloc] init];
        self.busStopAnnotation.coordinate = coord;
        self.busStopAnnotation.title = [busStop objectForKey:@"cta_stop_name"];
        [self.mapView addAnnotation:self.busStopAnnotation];

        //NSLog(@"adding: %@",self.busStopAnnotation.title);
    }
}

@end
