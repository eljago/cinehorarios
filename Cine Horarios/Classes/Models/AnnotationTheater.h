//
//  AnnotationTheater2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Theater;

@interface AnnotationTheater : NSObject <MKAnnotation>

@property (nonatomic, assign, readonly) NSUInteger theaterID;
@property (nonatomic, assign, readonly) NSUInteger cinemaID;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, assign, readwrite) double distance;
@property (nonatomic, strong, readonly) NSString *webURL;
@property (nonatomic, strong, readonly) NSString *information;

- (id)initWithTheater:(Theater *)theater;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSComparisonResult) compareAnnotationsDistance: (AnnotationTheater *)annotation;

@end