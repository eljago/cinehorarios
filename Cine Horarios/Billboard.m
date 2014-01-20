//
//  Billboard.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Billboard.h"
#import "BasicMovie2.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "NSFileManager+CH.h"

NSString *const kBillboardPath = @"/api/shows/billboard.json";
NSString *const kBillboardArchivePath = @"/data/";

@implementation Billboard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)moviesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:BasicMovie2.class];
}

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
    return [self loadFromPath:[self storagePathBillboard]];
}

+ (NSString *)storagePathBillboard
{
    return [[NSFileManager storagePathForPath:kBillboardArchivePath] stringByAppendingPathComponent:@"billboard.data"];
}

@end
