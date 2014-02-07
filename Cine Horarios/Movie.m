//
//  Movie2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Movie.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"
#import "Person.h"
#import "Video.h"

NSString *const kMoviePath = @"/api/shows/%d.json";
NSString *const kMovieArchivePath = @"/data/shows/";

@implementation Movie

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"imageURL": @"image_url",
             @"nameOriginal": @"name_original",
             @"metacriticURL": @"metacritic_url",
             @"metacriticScore": @"metacritic_score",
             @"imdbCode": @"imdb_code",
             @"imdbScore": @"imdb_score",
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

+ (void)getCinemaWithBlock:(void (^)(Movie *movie, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:kMoviePath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Movie *movie = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        NSMutableArray *images = [movie.images mutableCopy];
        [images addObject:movie.imageURL];
        movie.images = [NSArray arrayWithArray:images];
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
    return [self loadIfOlderThanThreeHoursFromPath:[self storagePathForMovieID:movieID]];
}

+ (NSString *)storagePathForMovieID:(NSUInteger)movieID
{
    return [[self storagePathForPath:kMovieArchivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.data",movieID]];
}

@end
