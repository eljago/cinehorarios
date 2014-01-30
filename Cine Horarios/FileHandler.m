//
//  FileHandler.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FileHandler.h"

NSTimeInterval const kMaxDataDurationTime = 60*60*3;
NSTimeInterval const kMaxImageDurationTime = 60*60*24*7;

@implementation FileHandler

+ (NSDictionary *) getDictionaryInProjectNamed: (NSString *) plistName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[plistName stringByAppendingString:@".plist"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (void) removeOldImages {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSString *imagesDir = [cacheDir stringByAppendingPathComponent:@"images"];
    if ([filemgr createDirectoryAtPath:imagesDir withIntermediateDirectories:YES attributes:nil error:NULL]) {
        // Failed to create Directory
    }
    NSArray *filelist = [filemgr contentsOfDirectoryAtPath:imagesDir error:NULL];
    
    for (int i = 0; i < [filelist count]; i++) {
        NSString *filePath = [imagesDir stringByAppendingPathComponent:filelist[i]];
        NSDictionary *attributes = [filemgr attributesOfItemAtPath:filePath error:nil];
        NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
        
        if ([[NSDate date] timeIntervalSinceDate:creationDate] > kMaxImageDurationTime) {
            [filemgr removeItemAtPath:filePath error: NULL];
        }
    }
}

+ (void) cleanDirectoryAtPath: (NSString *) path {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL isDirectory;
    BOOL fileExistsAtPath = [filemgr fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (fileExistsAtPath && isDirectory) {
        
        NSArray *fileList = [filemgr contentsOfDirectoryAtPath:path error:NULL];
        if (fileList.count == 0) {
            [filemgr removeItemAtPath:path error: NULL];
        }
        else {
            for (NSString *item in fileList){
                
                NSString *itemPath = [path stringByAppendingPathComponent:item];
                BOOL isDirectory2;
                BOOL fileExistsAtPath = [filemgr fileExistsAtPath:itemPath isDirectory:&isDirectory2];
                if (fileExistsAtPath && isDirectory2) {
                    [self cleanDirectoryAtPath:itemPath];
                }
                else if (fileExistsAtPath && !isDirectory2) {
                    [self deleteFileAtPath:itemPath ifOlderThanTimeInterval:kMaxDataDurationTime currentDate:currentDate calendar:calendar];
                }
            }
        }
    }
}

+ (void) deleteFileAtPath:(NSString *)path ifOlderThanTimeInterval:(NSTimeInterval)timeInterval currentDate:(NSDate *)currentDate calendar:(NSCalendar *)calendar {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:currentDate];
    NSInteger dayNow = [components day];
    NSInteger monthNow = [components month];
    
    NSDictionary *attributes = [filemgr attributesOfItemAtPath:path error:nil];
    NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
    NSDateComponents *components2 = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:creationDate];
    NSInteger dayFileCreated = [components2 day];
    NSInteger monthFileCreated = [components2 month];
    
    if (dayNow != dayFileCreated || monthNow != monthFileCreated || [currentDate timeIntervalSinceDate:creationDate] > timeInterval) {
        [filemgr removeItemAtPath:path error: NULL];
    }
}



#pragma mark - Get Full Local Path for Path

+ (NSString *)getFullLocalPathForPath:(NSString *)path fileName:(NSString *)fileName{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localDirPath = [cacheDir stringByAppendingPathComponent:path];
    if ([filemgr createDirectoryAtPath:localDirPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
        // Failed to create Directory
    }
    return [localDirPath stringByAppendingPathComponent:fileName];
}

#pragma mark - Get Menu Items
+ (void)getMenuDictsAndSelectedIndex:(void (^)(NSArray *menuDicts, NSInteger selectedIndex))block withStoryboardID:(NSString *)identifier {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menu = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger selectedIndex = 0;
    
    NSMutableArray *startingVCsMutable = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in menu) {
        NSArray *items = dict[@"items"];
        for (NSDictionary *dict in items) {
            [startingVCsMutable addObject:dict];
            if ([dict[@"storyboardID"] isEqualToString:identifier]) {
                selectedIndex = startingVCsMutable.count-1;
            }
        }
    }
    block([NSArray arrayWithArray:startingVCsMutable], selectedIndex);
}

@end
