//
//  Theater2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Theater.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "Function.h"
#import "NSArray+FKBMap.h"

NSString *const kTheaterPath = @"/api/theaters/%lu.json?date=%@";
NSString *const kTheaterArchivePath = @"/data/theaters/";

NSString *const kShowTheatersPath = @"/api/shows/%lu/show_theaters.json";

@implementation Theater

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"theaterID": @"id",
             @"cinemaID": @"cinema_id",
             @"webURL": @"web_url"
             };
}

+ (NSValueTransformer *)functionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Function.class];
}

+ (void)getTheaterWithBlock:(void (^)(Theater *theater, NSError *error))block theaterID:(NSUInteger)theaterID date:(NSDate *) date {
    NSString *stringDate = [self getStringFromDate:date];
    NSString *path = [NSString stringWithFormat:kTheaterPath,(unsigned long)theaterID, stringDate];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSError *theError = nil;
        Theater *theater = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSON error:&theError];
        [theater persistToFile:[[self class] storagePathForTheaterID:theaterID date:date]];
        
        if (block) {
            block(theater, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (id)loadTheaterithTheaterID:(NSUInteger)theaterID date:(NSDate *) date
{
    return [self loadIfOlderThanThreeHoursFromPath:[self storagePathForTheaterID:theaterID date: date]];
}

+ (NSString *)storagePathForTheaterID:(NSUInteger)theaterID date:(NSDate *)date
{
    NSString *stringDate = [self getStringFromDate:date];
    return [[self storagePathForPath:kTheaterArchivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu_%@.data",(unsigned long)theaterID, stringDate]];
}


+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:kShowTheatersPath,(unsigned long)movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaters = [JSON fkbMap:^Theater *(NSDictionary *theaterDictionary) {
            NSError *error = nil;
            return [MTLJSONAdapter modelOfClass:Theater.class fromJSONDictionary:theaterDictionary error:&error];
        }];
        
        if (block) {
            block(theaters, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSString *) getStringFromDate:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:date];
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate:date];
//    NSString *dateString2 = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
//    NSLog(@"%@\n%@",dateString, dateString2);
    
    return dateString;
}

@end
