//
//  MyCustomAnnotation.h
//  GetOnThatBus
//
//  Created by Eduardo Alvarado Díaz on 10/14/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

@property NSString *intermodal;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
