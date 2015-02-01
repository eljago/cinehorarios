//
//  Function2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Function.h"
#import "CineHorariosApiClient.h"
#import "Theater.h"
#import "NSArray+FKBMap.h"

NSString *const RemoteMovieTheaterFunctionsPath = @"/api/shows/%lu/favorite_theaters.json";

@implementation Function

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"portraitImageURL": @"portrait_image",
             @"imageURL": @"image_url",
             @"functionTypes": @"function_types"
             };
}

+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaterFunctions, NSError *error))block movieID:(NSUInteger )movieID theaters:(NSArray *)theaters date:(NSDate *)date {
    NSString *stringDate = [self getStringFromDate:date];
    NSString *path = [NSString stringWithFormat:RemoteMovieTheaterFunctionsPath,(unsigned long)movieID];
    NSString *theatersString = [NSString stringWithFormat:@"%lu",(unsigned long)((Theater *)[theaters firstObject]).theaterID];
    for (int i=1; i<theaters.count;i++) {
        Theater *theater = theaters[i];
        theatersString = [theatersString stringByAppendingFormat:@",%lu",(unsigned long)theater.theaterID];
    }
    
    [[CineHorariosApiClient sharedClient] GET:path parameters:@{ @"favorites": theatersString, @"date": stringDate } success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaterFunctions = [JSON fkbMap:^Theater *(NSDictionary *theaterFunctionsDictionary) {
            return [MTLJSONAdapter modelOfClass:Theater.class fromJSONDictionary:theaterFunctionsDictionary error:NULL];
        }];
        
        if (block) {
            block(theaterFunctions, nil);
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
