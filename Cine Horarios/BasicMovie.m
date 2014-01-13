//
//  ShowItem.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicMovie.h"
#import "CineHorariosApiClient.h"
#import "FileHandler.h"

NSString *const LocalCarteleraPath = @"/jsons/shows";
NSString *const RemoteCarteleraPath = @"/api/shows/billboard.json";
NSString *const LocalComingSoonPath = @"/jsons/shows";
NSString *const RemoteComingSoonPath = @"/api/shows/comingsoon.json";

@implementation BasicMovie

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    
    if ([attributes valueForKeyPath:@"genres.name"] && [[attributes valueForKeyPath:@"genres.name"] count]) {
        _genres = [[attributes valueForKeyPath:@"genres.name"] componentsJoinedByString:@", "];
    }
    
    if (![[attributes valueForKey:@"duration"] isKindOfClass:[NSNull class]]) {
        _duration = [NSString stringWithFormat:@"%d minutos",[[attributes valueForKey:@"duration"] intValue]];
    }
    
    if (![[attributes valueForKey:@"debut"] isKindOfClass:[NSNull class]]) {
        NSString *debut = [attributes valueForKey:@"debut"];
        NSDateFormatter *stringFromDateFormatter = [[NSDateFormatter alloc] init];
        [stringFromDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"]];
        [stringFromDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [stringFromDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        //[stringFromDateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDateFormatter *dateFromStringFormatter = [[NSDateFormatter alloc] init];
        [dateFromStringFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        _debut = [stringFromDateFormatter stringFromDate:[dateFromStringFormatter dateFromString:debut]];
    }
    
    if (![[attributes valueForKey:@"portrait_image"] isEqual:[NSNull null]]) {
        _portraitImageURL = [attributes valueForKey:@"portrait_image"];
    }
    
    return self;
}

+ (NSArray *) BasicMoviesFromJSON:(id) JSON {
    NSMutableArray *mutableItems;
    if ([JSON isKindOfClass:[NSArray class]]) {
        if ([JSON count] > 0) {
            mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *showAttributes in JSON) {
                BasicMovie *movie = [[BasicMovie alloc] initWithAttributes:showAttributes];
                [mutableItems addObject:movie];
            }
        }
    }
    else{
        mutableItems = [[NSMutableArray alloc] initWithObjects:[[BasicMovie alloc] initWithAttributes:JSON], nil];
    }
    return [NSArray arrayWithArray:mutableItems];
}

#pragma mark - CarteleraVC

+ (NSArray *) getLocalCartelera {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:LocalCarteleraPath fileName:@"billboard.json"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *theaters = [BasicMovie BasicMoviesFromJSON:JSON];
        return theaters;
    }
    else {
        return [NSArray array];
    }
}
+ (void)getCarteleraWithBlock:(void (^)(NSArray *movies, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:RemoteCarteleraPath parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *movies = [BasicMovie BasicMoviesFromJSON:JSON];
        
        if (movies.count > 0) {
            NSError *theError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:LocalCarteleraPath
                                                                  fileName:@"billboard.json"]
                             contents:jsonData
                           attributes:nil];
        }
        
        if (block) {
            block(movies, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

#pragma mark - ComingSoonVC

+ (NSArray *) getLocalComingSoon {
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:LocalComingSoonPath fileName:@"comingsoon.json"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *theaters = [BasicMovie BasicMoviesFromJSON:JSON];
        return theaters;
    }
    else {
        return [NSArray array];
    }
}
+ (void)getComingSoonWithBlock:(void (^)(NSArray *movies, NSError *error))block {
    [[CineHorariosApiClient sharedClient] GET:RemoteComingSoonPath parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *movies = [BasicMovie BasicMoviesFromJSON:JSON];
        
        if (movies.count > 0) {
            NSError *theError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:LocalComingSoonPath
                                                                  fileName:@"comingsoon.json"]
                             contents:jsonData
                           attributes:nil];
        }
        
        if (block) {
            block(movies, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
