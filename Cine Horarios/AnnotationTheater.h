//
//  MyAnnotation.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-11-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Theater.h"

@interface AnnotationTheater : Theater <MKAnnotation>

@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readwrite, assign) double distance;

- (id)initWithAttributes:(NSDictionary *)attributes;
-(NSComparisonResult)compareAnnotationsDistance: (AnnotationTheater *)annotation;
+ (NSMutableArray *) getLocalAnnotations;
+ (void)getAnnotationsWithBlock:(void (^)(NSMutableArray *annotations, NSError *error))block;

@end
