//
//  Function2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Function2.h"
#import "CineHorariosApiClient.h"
#import "Theater2.h"
#import "NSArray+FKBMap.h"

NSString *const RemoteMovieTheaterFunctionsPath = @"/api/shows/%d/favorite_theaters.json";

@implementation Function2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"portraitImageURL": @"portrait_image",
             @"imageURL": @"image_url",
             @"functionTypes": @"function_types"
             };
}

+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaterFunctions, NSError *error))block movieID:(NSUInteger )movieID theaters:(NSArray *)theaters {
    NSString *path = [NSString stringWithFormat:RemoteMovieTheaterFunctionsPath,movieID];
    NSString *theatersString = [NSString stringWithFormat:@"%d",((Theater2 *)[theaters firstObject]).theaterID];
    for (int i=1; i<theaters.count;i++) {
        Theater2 *theater = theaters[i];
        theatersString = [theatersString stringByAppendingFormat:@",%d",theater.theaterID];
    }
    
    [[CineHorariosApiClient sharedClient] GET:path parameters:@{ @"favorites": theatersString } success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaterFunctions = [JSON fkbMap:^Theater2 *(NSDictionary *theaterFunctionsDictionary) {
            return [MTLJSONAdapter modelOfClass:Theater2.class fromJSONDictionary:theaterFunctionsDictionary error:NULL];
        }];
        
        if (block) {
            block(theaterFunctions, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
