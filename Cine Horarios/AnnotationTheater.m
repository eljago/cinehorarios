//
//  MyAnnotation.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-11-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AnnotationTheater.h"
#import "FileHandler.h"
#import "CineHorariosApiClient.h"

NSString *const kRemoteCoordinatesURL = @"/api/theaters/theater_coordinates.json";
NSString *const kLocalCoordinatesURL = @"/jsons/theaters";

@implementation AnnotationTheater

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    _title = self.name;
    _subtitle = attributes[@"address"];
    if (![attributes[@"latitude"] isEqual:[NSNull null]] && ![attributes[@"longitude"] isEqual:[NSNull null]]) {
        _coordinate = CLLocationCoordinate2DMake([attributes[@"latitude"] doubleValue], [attributes[@"longitude"] doubleValue]);
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

+(NSMutableArray *) annotationsWithJSON:(id)JSON {
    NSMutableArray *mutableItems;
    if ([JSON isKindOfClass:[NSArray class]]) {
        if ([JSON count] > 0) {
            mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *showAttributes in JSON) {
                AnnotationTheater *annotation = [[AnnotationTheater alloc] initWithAttributes:showAttributes];

                if (annotation.coordinate.latitude && annotation.coordinate.longitude) {
                    [mutableItems addObject:annotation];
                }
            }
        }
    }
    else{
        mutableItems = [[NSMutableArray alloc] initWithObjects:[[AnnotationTheater alloc] initWithAttributes:JSON], nil];
    }
    return mutableItems;
}

#pragma mark - Close Theaters

+ (NSMutableArray *) getLocalAnnotations {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:kLocalCoordinatesURL fileName:@"theater_annotations.json"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSMutableArray *annotations = [AnnotationTheater annotationsWithJSON:JSON];
        return annotations;
    }
    else {
        return [NSMutableArray array];
    }
}
+ (void)getAnnotationsWithBlock:(void (^)(NSMutableArray *annotations, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:kRemoteCoordinatesURL parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSMutableArray *annotations = [self annotationsWithJSON:JSON];
        
        if (annotations.count > 0) {
            NSError *theError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:kLocalCoordinatesURL
                                                                  fileName:@"theater_annotations.json"]
                             contents:jsonData
                           attributes:nil];
        }
        
        if (block) {
            block(annotations, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSMutableArray array], error);
        }
    }];
}

@end
