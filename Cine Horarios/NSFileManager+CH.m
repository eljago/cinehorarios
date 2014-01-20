//
//  NSFileManager+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "NSFileManager+CH.h"

NSUInteger const kMaxFileDuration = 60*3;

@implementation NSFileManager (CH)

+(BOOL)isFileOldWithPath:(NSString *)path {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:currentDate];
    
    NSDictionary *attributes = [[self defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
    NSDateComponents *components2 = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:creationDate];
    
    return ([components day] != [components2 day] ||
            [components month] != [components2 month] ||
            [currentDate timeIntervalSinceDate:creationDate] > kMaxFileDuration);
}
+ (NSString *)storagePathForPath:(NSString *)path
{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storagePath = [cachesDirectory stringByAppendingPathComponent:path];
    
    if (![[self defaultManager] fileExistsAtPath:storagePath]) {
        [[self defaultManager] createDirectoryAtPath:storagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return storagePath;
}

@end
