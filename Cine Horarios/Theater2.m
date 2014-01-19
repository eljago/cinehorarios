//
//  Theater2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Theater2.h"
#import "CineHorariosApiClient.h"
#import "NSArray+FKBMap.h"

NSString *const PATH = @"/api/cinemas/%d/theaters.json";

@implementation Theater2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"theaterID": @"id",
             @"cinemaID": @"cinema_id"
             };
}

+ (void)getTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block cinemaID:(NSUInteger )cinemaID {
    NSString *path = [NSString stringWithFormat:PATH,cinemaID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaters = [(NSArray *)JSON fkbMap:^Theater2 *(NSDictionary *theaterDictionary) {
            NSError *theError = nil;
            return [MTLJSONAdapter modelOfClass:Theater2.class fromJSONDictionary:theaterDictionary error:&theError];
        }];
        
        if (block) {
            block(theaters, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
