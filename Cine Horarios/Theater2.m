//
//  Theater2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Theater2.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "Function2.h"
#import "NSFileManager+CH.h"
#import "NSArray+FKBMap.h"

NSString *const kTheaterPath = @"/api/theaters/%d.json";
NSString *const kTheaterArchivePath = @"/data/theaters/";

NSString *const kShowTheatersPath = @"/api/shows/%d/show_theaters.json";

@implementation Theater2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"theaterID": @"id",
             @"cinemaID": @"cinema_id",
             @"webURL": @"web_url"
             };
}

+ (NSValueTransformer *)functionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Function2.class];
}

+ (void)getTheaterWithBlock:(void (^)(Theater2 *theater, NSError *error))block theaterID:(NSUInteger)theaterID {
    NSString *path = [NSString stringWithFormat:kTheaterPath,theaterID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Theater2 *theater = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        [theater persistToFile:[[self class] storagePathForTheaterID:theaterID]];
        
        if (block) {
            block(theater, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadTheaterithTheaterID:(NSUInteger)theaterID
{
    return [self loadFromPath:[self storagePathForTheaterID:theaterID]];
}

+ (NSString *)storagePathForTheaterID:(NSUInteger)theaterID
{
    return [[NSFileManager storagePathForPath:kTheaterArchivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.data",theaterID]];
}


+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:kShowTheatersPath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaters = [JSON fkbMap:^Theater2 *(NSDictionary *theaterDictionary) {
            NSError *error = nil;
            return [MTLJSONAdapter modelOfClass:Theater2.class fromJSONDictionary:theaterDictionary error:&error];
        }];
        
        if (block) {
            block(theaters, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
