//
//  MyCustomAnnotation.m
//  GetOnThatBus
//
//  Created by Eduardo Alvarado Díaz on 10/14/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

- (MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"pin_red"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return annotationView;
}

@end
