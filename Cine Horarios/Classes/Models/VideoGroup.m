//
//  VideoGroup.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoGroup.h"
#import "CineHorariosApiClient.h"
#import "Video.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

NSString *const kVideoGroupPath = @"/api/videos.json?page=%lu";
NSString *const kVideoGroupArchivePath = @"/data/";

@implementation VideoGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)videosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Video.class];
}

+ (void)getVideosWithBlock:(void (^)(VideoGroup *videoGroup, NSError *error))block page:(NSUInteger)page {
    NSString *path = [NSString stringWithFormat:kVideoGroupPath, (unsigned long)page];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *error = nil;
        VideoGroup *videoGroup = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&error];
        if (page == 1) {
            [videoGroup persistToFile:[[self class] storagePath]];
        }
        
        if (block) {
            block(videoGroup, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadVideoGroup
{
    return [self loadIfOlderThanThreeHoursFromPath:[self storagePath]];
}

+ (NSString *)storagePath
{
    return [[self storagePathForPath:kVideoGroupArchivePath] stringByAppendingPathComponent:@"videos.data"];
}

@end
