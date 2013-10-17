//
//  Theater.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Theater.h"
#import "CineHorariosApiClient.h"
#import "FileHandler.h"

NSString *const LocalCinemaTheatersPath = @"/jsons/theaters";
NSString *const RemoteCinemaTheatersPath = @"/api/cinemas/%d/theaters.json";

NSString *const LocalMovieTheatersPath = @"/jsons/shows/%d";
NSString *const RemoteMovieTheatersPath = @"/api/shows/%d/show_theaters.json";

@implementation Theater

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    if ([attributes valueForKey:@"cinema_id"]) {
        _cinemaID = [[attributes valueForKey:@"cinema_id"] integerValue];
    }
    
    return self;
}

+ (NSArray *) theatersFromJSON:(id) JSON {
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    for (NSDictionary *theaterAttributes in JSON) {
        Theater *theater = [[Theater alloc] initWithAttributes:theaterAttributes];
        [mutableItems addObject:theater];
    }
    
    return [NSArray arrayWithArray:mutableItems];
}


#pragma mark - TheatersVC

+ (NSArray *) getLocalTheatersWithCinemaID:(NSUInteger) cinemaID {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:LocalCinemaTheatersPath fileName:[NSString stringWithFormat:@"%d.json",cinemaID]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *theaters = [Theater theatersFromJSON:JSON];
        return theaters;
    }
    else {
        return nil;
    }
}

+ (void)getTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block cinemaID:(NSUInteger )cinemaID {
    NSString *path = [NSString stringWithFormat:RemoteCinemaTheatersPath,cinemaID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *theError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:LocalCinemaTheatersPath fileName:[NSString stringWithFormat:@"%d.json",cinemaID]] contents:jsonData attributes:nil];
        
        NSArray *theaters = [Theater theatersFromJSON:JSON];
        
        if (block) {
            block(theaters, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

#pragma mark - MovieTheatersVC

+ (NSArray *) getLocalMovieTheatersWithMovieID:(NSUInteger) movieID {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMovieTheatersPath, movieID] fileName:@"theaters.json"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *theaters = [Theater theatersFromJSON:JSON];
        return theaters;
    }
    else {
        return [NSArray array];
    }
}
+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:RemoteMovieTheatersPath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaters = [Theater theatersFromJSON:JSON];
        
        if (theaters.count > 0) {
            NSError *theError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMovieTheatersPath, movieID] fileName:@"theaters.json"] contents:jsonData attributes:nil];
        }
        
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
