//
//  AnnotationTheater2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AnnotationTheater.h"

@implementation AnnotationTheater

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _theaterID = [dictionary[@"id"] unsignedIntegerValue];
        _cinemaID = [dictionary[@"cinema_id"] unsignedIntegerValue];
        if (![dictionary[@"latitude"] isEqual:[NSNull null]] && ![dictionary[@"longitude"] isEqual:[NSNull null]]) {
            _coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"] doubleValue]);
        }
        else {
            _coordinate = CLLocationCoordinate2DMake(0, 0);
        }
        _title = dictionary[@"name"];
        _subtitle = dictionary[@"address"];
    }
    
    return self;
}

-(NSComparisonResult)compareAnnotationsDistance: (AnnotationTheater *)annotation{
    if (annotation.distance == self.distance) {
        return NSOrderedSame;
    }
    else if(annotation.distance > self.distance){
        return NSOrderedAscending;
    }
    else
        return NSOrderedDescending;
}

@end
