//
//  Movie2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Movie2.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "Person.h"
#import "Video.h"
#import "NSFileManager+CH.h"

NSString *const kMoviePath = @"/api/shows/%d.json";
NSString *const kMovieArchivePath = @"/data/shows/";

@implementation Movie2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"imageURL": @"image_url",
             @"nameOriginal": @"name_original",
             @"metacriticURL": @"metacritic_url",
             @"metacriticScore": @"metacritic_score",
             @"imdbCode": @"imdb_code",
             @"rottenTomatoesURL": @"rotten_tomatoes_url",
             @"rottenTomatoesScore": @"rotten_tomatoes_score",
             @"images": @"images.image_url"
             };
}

+ (NSValueTransformer *)peopleJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Person.class];
}
+ (NSValueTransformer *)videosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Video.class];
}

+ (void)getCinemaWithBlock:(void (^)(Movie2 *movie, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:kMoviePath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Movie2 *movie = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        [movie persistToFile:[[self class] storagePathForMovieID:movieID]];
        
        if (block) {
            block(movie, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadMovieWithMovieID:(NSUInteger)movieID
{
    return [self loadFromPath:[self storagePathForMovieID:movieID]];
}

+ (NSString *)storagePathForMovieID:(NSUInteger)movieID
{
    return [[NSFileManager storagePathForPath:kMovieArchivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.data",movieID]];
}

@end
