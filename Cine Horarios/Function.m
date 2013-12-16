//
//  Function.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Function.h"
#import "CineHorariosApiClient.h"
#import "FileHandler.h"

NSString *const LocalFunctionsPath = @"/jsons/theaters/%d";
NSString *const RemoteFunctionsPath = @"api/theaters/%d/functions.json?date=%@";

NSString *const LocalMovieFunctionsPath = @"/jsons/shows/%d/theaters";
NSString *const RemoteMovieFunctionsPath = @"api/shows/%d/show_functions.json?theater_id=%d&date=%@";


@implementation Function

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    _types = [[attributes valueForKeyPath: @"function_types.name"] componentsJoinedByString:@", "];
    
    NSDateFormatter *dateFromStringFormatter = [[NSDateFormatter alloc] init];
//    [dateFromStringFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [dateFromStringFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDateFormatter *stringFromDateFormatter = [[NSDateFormatter alloc] init];
    [stringFromDateFormatter setDateFormat:@"HH':'mm"];
    NSDateFormatter *hourStringFromDate = [[NSDateFormatter alloc] init];
    [hourStringFromDate setDateFormat:@"HH"];
    NSLocale *esCL = [[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"];
    [dateFromStringFormatter setLocale:esCL];
    [stringFromDateFormatter setLocale:esCL];
    [hourStringFromDate setLocale:esCL];
    
//    NSArray *timesArray = [attributes valueForKeyPath:@"showtimes"];
    NSArray *timesArray = [attributes valueForKeyPath:@"showtimes.time"];
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    NSMutableArray *pastMidnightTimes = [[NSMutableArray alloc] init];
    for (NSString *time in timesArray) {
        NSUInteger hour = [[hourStringFromDate stringFromDate:[dateFromStringFormatter dateFromString:time]] integerValue];
        if ( hour < 7) {
            [pastMidnightTimes addObject:[stringFromDateFormatter stringFromDate:[dateFromStringFormatter dateFromString:time]]];
        }
        else{
            [mutaArray addObject:[stringFromDateFormatter stringFromDate:[dateFromStringFormatter dateFromString:time]]];
        }
    }
    _showtimes = [[mutaArray arrayByAddingObjectsFromArray:pastMidnightTimes] componentsJoinedByString:@", "];
    
    
    if (![[attributes valueForKey:@"portrait_image"] isEqual:[NSNull null]]) {
        _portraitImageURL = [attributes valueForKey:@"portrait_image"];
    }
    
    return self;
}

+ (NSArray *) functionsFromJSON:(id) JSON {

    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    for (NSDictionary *functionAttributes in [JSON valueForKey:@"functions"]) {
        Function *item = [[Function alloc] initWithAttributes:functionAttributes];
        [mutableItems addObject:item];
    }
    
    return [NSArray arrayWithArray:mutableItems];
}
+ (NSArray *) movieFunctionsFromJSON:(id) JSON {
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    for (NSDictionary *functionAttributes in JSON) {
        Function *item = [[Function alloc] initWithAttributes:functionAttributes];
        [mutableItems addObject:item];
    }
    
    return [NSArray arrayWithArray:mutableItems];
}

#pragma mark - FunctionsVC

+ (NSArray *) getLocalFunctionsWithTheaterID:(NSUInteger) theaterID dateString:(NSString *)dateString {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalFunctionsPath, theaterID]
                                                          fileName:@"functions.json"];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *functions = [Function functionsFromJSON:JSON];
        return functions;
    }
    else {
        return [NSArray array];
    }
}

+ (void)getFunctionsWithBlock:(void (^)(NSArray *functions, NSString *theater_url, NSError *error))block
                                      theaterID:(NSUInteger )theaterID
                                           date:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",[components year], [components month], [components day]];
    NSString *path = [NSString stringWithFormat:RemoteFunctionsPath,theaterID,dateString];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *functions = [Function functionsFromJSON:JSON];
        
        if (functions.count > 0) {
            NSError *theError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
            
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalFunctionsPath, theaterID]
                                                                  fileName:@"functions.json"]
                             contents:jsonData
                           attributes:nil];
        }
        
        NSString *theater_url = JSON[@"web_url"];
        
        if (block) {
            block(functions, theater_url, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], nil, error);
        }
    }];
}

#pragma mark - MovieFunctionsVC
+ (NSArray *) getLocalMovieFunctionsWithMovieID:(NSUInteger) movieID theaterID:(NSUInteger)theaterID dateString:(NSString *)dateString {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *localJsonPath = [FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMovieFunctionsPath, movieID]
                                                          fileName:[NSString stringWithFormat:@"%d.json",theaterID]];
    
    if ([filemgr fileExistsAtPath:localJsonPath]) {
        NSData *jsonData = [NSData dataWithContentsOfFile: localJsonPath];
        NSError *theError = nil;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&theError];
        NSArray *functions = [Function movieFunctionsFromJSON:JSON];
        return functions;
    }
    else {
        return nil;
    }
}
+ (void)getMovieFunctionsWithBlock:(void (^)(NSArray *functions, NSError *error))block
                     movieID:(NSUInteger )movieID
                    theaterID:(NSUInteger )theaterID
                         date:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",[components year], [components month], [components day]];
    NSString *path = [NSString stringWithFormat:RemoteMovieFunctionsPath,movieID,theaterID,dateString];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *theError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&theError];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        [filemgr createFileAtPath:[FileHandler getFullLocalPathForPath:[NSString stringWithFormat:LocalMovieFunctionsPath, movieID]
                                                              fileName:[NSString stringWithFormat:@"%d.json",theaterID]]
                         contents:jsonData
                       attributes:nil];
        
        NSArray *functions = [Function movieFunctionsFromJSON:JSON];
        
        if (block) {
            block(functions, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
