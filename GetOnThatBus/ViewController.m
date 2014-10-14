//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Eduardo Alvarado Díaz on 10/14/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailStopViewController.h"
#import "MyCustomAnnotation.h"

@interface ViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *stopArray;
@property NSDictionary *busStopSelected;
@property MyCustomAnnotation *busStopAnnotation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.segmentedControl.selectedSegmentIndex = 0;
    self.tableView.hidden = YES;
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

        [self.tableView reloadData];
        [self addAnnotations];
        [self zoomInChicago];
    }];
}

- (void)addAnnotations{
    for (NSDictionary *busStop in self.stopArray) {
        CLLocationCoordinate2D coord;
        coord.latitude = [[busStop objectForKey:@"latitude"] doubleValue];
        coord.longitude = [[busStop objectForKey:@"longitude"] doubleValue];

        self.busStopAnnotation = [[MyCustomAnnotation alloc] initWithTitle:[busStop objectForKey:@"cta_stop_name"] Location:coord];
        self.busStopAnnotation.subtitle = [busStop objectForKey:@"routes"];

        NSString *inter = [busStop objectForKey:@"inter_modal"];
        if (inter != nil) {
            if ([inter isEqualToString:@"Metra"]) {
                self.busStopAnnotation.intermodal = @"Metra";
            }else{
                self.busStopAnnotation.intermodal = @"Pace";
            }
        }else{
            self.busStopAnnotation.intermodal = @"";
        }

        [self.mapView addAnnotation:self.busStopAnnotation];
    }
}

- (void)zoomInChicago{
    CLLocationCoordinate2D zoomChicago;
    zoomChicago.latitude = 41.8119;
    zoomChicago.longitude = -87.6873;

    MKCoordinateSpan span;
    span.latitudeDelta = .4;
    span.longitudeDelta = .4;

    MKCoordinateRegion region;
    region.center = zoomChicago;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MyCustomAnnotation *myAnnotation = (MyCustomAnnotation *)annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if ([myAnnotation.intermodal isEqualToString:@"Metra"]) {
        pin.image = [UIImage imageNamed:@"pin_blue"];
    }else if ([myAnnotation.intermodal isEqualToString:@"Pace"]){
        pin.image = [UIImage imageNamed:@"pin_yellow"];
    }else{
        pin.image = [UIImage imageNamed:@"pin_red"];
    }

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSString *annotationTitle = view.annotation.title;
    NSLog(@"callout tapped in: %@",annotationTitle);
    for (NSDictionary *busStop in self.stopArray) {
        NSString *busStopName = [busStop objectForKey:@"cta_stop_name"];
        if ([busStopName isEqualToString:annotationTitle]) {
            self.busStopSelected = busStop;
        }
    }

    [self performSegueWithIdentifier:@"detailStop" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailStopViewController *destination = [segue destinationViewController];
    destination.busStop = self.busStopSelected;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stopArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];

    NSDictionary *item = [self.stopArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"cta_stop_name"];
    cell.detailTextLabel.text = [item objectForKey:@"routes"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.busStopSelected = [self.stopArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailStop" sender:tableView];
}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    UISegmentedControl *segmentedControl = sender;
    NSInteger selectedIndex = segmentedControl.selectedSegmentIndex;
    if (selectedIndex == 0) {
        //map
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
    }else{
        //table
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

@end
