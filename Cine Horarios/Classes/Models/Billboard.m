//
//  Billboard.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Billboard.h"
#import "BasicMovie.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

NSString *const kBillboardPath = @"/api/shows/billboard.json";
NSString *const kComingSoonPath = @"/api/shows/comingsoon.json";
NSString *const kBillboardArchivePath = @"/data/";

@implementation Billboard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)moviesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:BasicMovie.class];
}

// BILLBOARD

+ (void)getBillboardWithBlock:(void (^)(Billboard *billboard, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:kBillboardPath parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Billboard *billboard = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        [billboard persistToFile:[self storagePathBillboard]];
        
        if (block) {
            block(billboard, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadBillboard
{
    return [self loadIfOlderThanThreeHoursFromPath:[self storagePathBillboard]];
}

+ (NSString *)storagePathBillboard
{
    return [[self storagePathForPath:kBillboardArchivePath] stringByAppendingPathComponent:@"billboard.data"];
}

// COMING SOON

+ (void)getComingSoonWithBlock:(void (^)(Billboard *billboard, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:kComingSoonPath parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Billboard *billboard = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        [billboard persistToFile:[self storagePathComingSoon]];
        
        if (block) {
            block(billboard, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadComingSoon
{
    return [self loadIfOlderThanThreeHoursFromPath:[self storagePathComingSoon]];
}

+ (NSString *)storagePathComingSoon
{
    return [[self storagePathForPath:kBillboardArchivePath] stringByAppendingPathComponent:@"comingsoon.data"];
}

@end
