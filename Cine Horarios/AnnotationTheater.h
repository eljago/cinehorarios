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

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)getAnnotationsWithBlock:(void (^)(NSArray *annotations, NSError *error))block;

@end
