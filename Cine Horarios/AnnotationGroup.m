//
//  AnnotationGroup.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AnnotationGroup.h"
#import "CineHorariosApiClient.h"
#import "NSFileManager+CH.h"

NSString *const kAnnotationGroupPath = @"/api/theaters/theater_coordinates.json";
NSString *const kAnnotationGroupArchivePath = @"/data/";

@implementation AnnotationGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (void)getAnnotationsWithBlock:(void (^)(AnnotationGroup *annotationGroup, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:kAnnotationGroupPath parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *error = nil;
        AnnotationGroup *annotationGroup = [MTLJSONAdapter modelOfClass:AnnotationGroup.class fromJSONDictionary:JSON error:&error];
        [annotationGroup persistToFile:[[self class] storagePath]];
        
        if (block) {
            block(annotationGroup, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadAnnotationGroup
{
    return [self loadFromPath:[self storagePath]];
}

+ (NSString *)storagePath
{
    return [[NSFileManager storagePathForPath:kAnnotationGroupArchivePath] stringByAppendingPathComponent:@"annotations.data"];
}

@end
