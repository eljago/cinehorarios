//
//  Cinema.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Cinema.h"
#import "Theater2.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLModel+NSCoding.h"
#import "NSFileManager+CH.h"

NSString *const kCinemaPath = @"/api/cinemas/%d.json";
NSString *const kCinemaArchivePath = @"/data/cinemas/";

@implementation Cinema

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cinemaID": @"id"
             };
}

+ (NSValueTransformer *)theatersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Theater2.class];
}

+ (void)getCinemaWithBlock:(void (^)(Cinema *cinema, NSError *error))block cinemaID:(NSUInteger )cinemaID {
    NSString *path = [NSString stringWithFormat:kCinemaPath,cinemaID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Cinema *cinema = [MTLJSONAdapter modelOfClass:Cinema.class fromJSONDictionary:JSON error:&theError];
        [cinema persist];
        
        if (block) {
            block(cinema, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)persist
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    [data writeToFile:[[self class] storagePathForCinemaID:self.cinemaID] atomically:YES];
}

+ (id)loadTheaterWithCinemaID:(NSUInteger)cinemaID
{
    id item = nil;
    NSString *path = [self storagePathForCinemaID:cinemaID];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && ![NSFileManager isFileOldWithPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        item = [[[self class] alloc] initWithCoder:unarchiver];
        [unarchiver finishDecoding];
    }
    return item;
}

+ (NSString *)storagePathForCinemaID:(NSUInteger)cinemaID
{
    return [[NSFileManager storagePathForPath:kCinemaArchivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.data",cinemaID]];
}

@end
