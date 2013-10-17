//
//  MovieItem.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Movie.h"
#import "BasicImageItem.h"
#import "VideoItem.h"
#import "Actor.h"
#import "CineHorariosApiClient.h"
#import "FileHandler.h"

// image sizes
// url          [640,960]
// small.url    [320,480]
// smaller.url  [160,240]
// smallest.url [80,120]

NSString *const LocalMoviePath = @"/jsons/shows/%d";
NSString *const RemoteMoviePath = @"/api/shows/%d.json";

@implementation Movie

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    NSString *value = [attributes valueForKey:@"name_original"];
    if (![value isEqual:[NSNull null]] && ![value isEqualToString:@""]) {
        _nameOriginal = value;
    }
    value = [attributes valueForKey:@"information"];
    if (![value isEqual:[NSNull null]] && ![value isEqualToString:@""]) {
        _synopsis = value;
    }
    value = [attributes valueForKey:@"year"];
    if (![value isEqual:[NSNull null]]) {
        _year = [NSString stringWithFormat:@"%d",[value intValue]];
    }
    value = [attributes valueForKey:@"rating"];
    if (![value isEqual:[NSNull null]]) {
        _rating = value;
    }
    
    value = [attributes valueForKey:@"metacritic_url"];
    if (![value isEqual:[NSNull null]]) {
        _urlMetacritic = value;
    }
    value = [attributes valueForKey:@"imdb_code"];
    if (![value isEqual:[NSNull null]]) {
        _urlImdb = value;
    }
    value = [attributes valueForKey:@"rotten_tomatoes_url"];
    if (![value isEqual:[NSNull null]]) {
        _urlRottenTomatoes = value;
    }
    
    value = [attributes valueForKey:@"metacritic_score"];
    if (![value isEqual:[NSNull null]]) {
        _scoreMetacritic = [NSString stringWithFormat:@"%d / 100",[value integerValue]];
    }
    value = [attributes valueForKey:@"imdb_score"];
    if (![value isEqual:[NSNull null]]) {
        _scoreImdb = [NSString stringWithFormat:@"%.1f / 10",[value floatValue] / 10];
    }
    value = [attributes valueForKey:@"rotten_tomatoes_score"];
    if (![value isEqual:[NSNull null]]) {
        _scoreRottenTomatoes = [NSString stringWithFormat:@"%d %%",[value integerValue]];
    }
    
    NSArray *array = [attributes valueForKey: @"videos"];
    NSMutableArray *videosMutable = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        [videosMutable addObject:[[VideoItem alloc] initWithAttributes:dict]];
    }
    _videos = [NSArray arrayWithArray:videosMutable];
    
    NSMutableArray *imagesMutableArray = [[attributes valueForKeyPath: @"images.image_url"] mutableCopy];
    [imagesMutableArray addObject:self.imageUrl];
    _images = [NSArray arrayWithArray:imagesMutableArray];
    
    array = [attributes valueForKey: @"people"];
    NSMutableArray *actorsMutable = [[NSMutableArray alloc] initWithCapacity:[array count]];
    NSMutableArray *directorsMutable = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        
        if ([[dict valueForKey:@"actor"] integerValue] == 1) {
            [actorsMutable addObject:[[Actor alloc] initWithAttributes:dict]];
        }
        if ([[dict valueForKey:@"director"] integerValue] == 1) {
            [directorsMutable addObject:[[Actor alloc] initWithAttributes:dict]];
        }
    }
    _actors = [NSArray arrayWithArray:actorsMutable];
    _directors = [NSArray arrayWithArray:directorsMutable];
    

    
    return self;
}

#pragma mark - MovieVC

+ (Movie *) getLocalMovieWithMovieID:(NSUInteger) movieID {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMoviePath,movieID]
                                                          fileName:@"info.json"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        Movie *movie = [[Movie alloc] initWithAttributes:JSON];
        return movie;
    }
    else {
        return nil;
    }
}

+ (void)getMovieWithBlock:(void (^)(Movie *movie, NSError *error))block
                                      movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:RemoteMoviePath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMoviePath,movieID]
                                                              fileName:@"info.json"]
                         contents:jsonData
                       attributes:nil];
        
       Movie *movie = [[Movie alloc] initWithAttributes:JSON];
        
        if (block) {
            block(movie, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
