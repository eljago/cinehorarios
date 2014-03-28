//
//  MTLModelPersistable.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLModel+NSCoding.h"

NSTimeInterval const kDurationThreeHours = 60*60*3;
NSTimeInterval const kDurationOneWeek = 60*60*24*7;

@implementation MTLModelPersistable

- (void)persistToFile:(NSString *)filePath
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (id)loadIfOlderThanThreeHoursFromPath:(NSString *)path
{
    id item = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && ![self isFileWithPath:path olderThan:kDurationThreeHours]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        item = [[[self class] alloc] initWithCoder:unarchiver];
        [unarchiver finishDecoding];
    }
    return item;
}

+ (id)loadIfOlderThanOneWeekFromPath:(NSString *)path
{
    id item = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && ![self isFileWithPath:path olderThan:kDurationOneWeek]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        item = [[[self class] alloc] initWithCoder:unarchiver];
        [unarchiver finishDecoding];
    }
    return item;
}

+ (NSString *)storagePathForPath:(NSString *)path
{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storagePath = [cachesDirectory stringByAppendingPathComponent:path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:storagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return storagePath;
}

+(BOOL)isFileWithPath:(NSString *)path olderThan:(NSUInteger)duration{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:currentDate];
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
    NSDateComponents *components2 = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:creationDate];
    
    return ([components day] != [components2 day] ||
            [components month] != [components2 month] ||
            [currentDate timeIntervalSinceDate:creationDate] > duration);
}


@end
