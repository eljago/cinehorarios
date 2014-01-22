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

NSString *const kTheaterPath = @"/api/theaters/%d.json";
NSString *const kTheaterArchivePath = @"/data/theaters/";

@implementation Theater2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"theaterID": @"id"
             };
}

+ (NSValueTransformer *)functionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Function2.class];
}

+ (void)getTheaterWithBlock:(void (^)(Theater2 *theater, NSError *error))block theaterID:(NSUInteger )theaterID {
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

@end
