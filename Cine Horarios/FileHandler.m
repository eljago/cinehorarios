//
//  FileHandler.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FileHandler.h"

//NSTimeInterval const kMaxJsonsDurationTime = 60*60*24*7;
NSTimeInterval const kMaxJsonsDurationTime = 0;
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"];
    
    for (int i = 0; i < [filelist count]; i++) {
        NSString *filePath = [imagesDir stringByAppendingPathComponent:filelist[i]];
        NSDictionary *attributes = [filemgr attributesOfItemAtPath:filePath error:nil];
        NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
        
        if ([[NSDate date] timeIntervalSinceDate:creationDate] > kMaxImageDurationTime) {
            if ([filemgr removeItemAtPath:filePath error: NULL] == YES) {
                
            }
            else{
                
            }
        }
    }
}

+ (void) removeOldJsons {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"];
    
    // Json path in cache dir
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *jsonsDir = [cacheDir stringByAppendingPathComponent:@"jsons"];
    if ([filemgr createDirectoryAtPath:jsonsDir withIntermediateDirectories:YES attributes:nil error:NULL]) {
        // Failed to create Directory
    }
    
    // Current Date
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Functions
    NSString *searchPath = [jsonsDir stringByAppendingPathComponent:@"theaters"];
    NSArray *fileList = [filemgr contentsOfDirectoryAtPath:searchPath error:NULL];
    BOOL isDirectory;
    for (NSString *item in fileList){
        
        NSString *itemPath = [searchPath stringByAppendingPathComponent:item];
        BOOL fileExistsAtPath = [filemgr fileExistsAtPath:itemPath isDirectory:&isDirectory];
        if (fileExistsAtPath && isDirectory) {
            //It's a Directory.
            NSArray *fileList2 = [filemgr contentsOfDirectoryAtPath:itemPath error:NULL];
            if (fileList2.count >0) {
                
                NSString *theaterFunctionsJSONPath = [itemPath stringByAppendingPathComponent:@"functions.json"];
                if ([filemgr fileExistsAtPath:theaterFunctionsJSONPath]) {
                    [self deleteFileAtPath:theaterFunctionsJSONPath ifOlderThanTimeInterval:kMaxJsonsDurationTime currentDate:currentDate calendar:calendar];
                }
            }
        }
//        if ([[item pathExtension] isEqualToString:@".json"]) {
//            //This is Image File with .json Extension
//        }
    }
    
    // Annotations
    NSString *theaterAnnotationsPath = [searchPath stringByAppendingPathComponent:@"theater_annotations.json"];
    if ([filemgr fileExistsAtPath:theaterAnnotationsPath]) {
        [self deleteFileAtPath:theaterAnnotationsPath ifOlderThanTimeInterval:kMaxJsonsDurationTime currentDate:currentDate calendar:calendar];
    }
    
    // Functions
    searchPath = [jsonsDir stringByAppendingPathComponent:@"shows"];
    fileList = [filemgr contentsOfDirectoryAtPath:searchPath error:NULL];
    for (NSString *item in fileList){
        
        NSString *itemPath = [searchPath stringByAppendingPathComponent:item];
        BOOL fileExistsAtPath = [filemgr fileExistsAtPath:itemPath isDirectory:&isDirectory];
        if (fileExistsAtPath && isDirectory) {
            
            NSArray *fileList2 = [filemgr contentsOfDirectoryAtPath:itemPath error:NULL];
            if (fileList2.count == 0) {
                [filemgr removeItemAtPath:itemPath error: NULL];
            }
            else if (fileList2.count == 1 && [fileList2[0] isEqualToString:@".DS_Store"]) {
                
                [filemgr removeItemAtPath:[itemPath stringByAppendingPathComponent:fileList2[0]] error: NULL];
                [filemgr removeItemAtPath:itemPath error: NULL];
            }
            else {
                for (NSString *item2 in fileList2){
                    
                    BOOL isDirectory2;
                    NSString *itemPath2 = [itemPath stringByAppendingPathComponent:item2];
                    BOOL fileExistsAtPath2 = [filemgr fileExistsAtPath:itemPath2 isDirectory:&isDirectory2];
                    if (fileExistsAtPath2 && isDirectory2) {
                        
                        NSArray *fileList3 = [filemgr contentsOfDirectoryAtPath:itemPath2 error:NULL];
                        if (fileList3.count == 0) {
                            [filemgr removeItemAtPath:itemPath2 error: NULL];
                        }
                        else if (fileList3.count == 1 && [fileList3[0] isEqualToString:@".DS_Store"]) {
                            
                            [filemgr removeItemAtPath:[itemPath2 stringByAppendingPathComponent:fileList3[0]] error: NULL];
                            [filemgr removeItemAtPath:itemPath2 error: NULL];
                        }
                        else {
                            for (NSString *item3 in fileList3) {
                                
                                BOOL isDirectory3;
                                NSString *itemPath3 = [itemPath2 stringByAppendingPathComponent:item3];
                                BOOL fileExistsAtPath3 = [filemgr fileExistsAtPath:itemPath3 isDirectory:&isDirectory3];
                                if (fileExistsAtPath3 && isDirectory3) {
                                    
                                    NSArray *fileList4 = [filemgr contentsOfDirectoryAtPath:itemPath3 error:NULL];
                                    if (fileList4.count == 0) {
                                        [filemgr removeItemAtPath:itemPath3 error: NULL];
                                    }
                                    else if (fileList4.count == 1 && [fileList4[0] isEqualToString:@".DS_Store"]) {
                                        
                                        [filemgr removeItemAtPath:[itemPath3 stringByAppendingPathComponent:fileList4[0]] error: NULL];
                                        [filemgr removeItemAtPath:itemPath3 error: NULL];
                                    }
                                    else {
                                        for (NSString *item4 in fileList4) {
                                            
                                            [filemgr removeItemAtPath:item4 error: NULL];
                                        }
                                    }
                                }
                                else if (fileExistsAtPath3 && !isDirectory3) {
                                    [self deleteFileAtPath:itemPath3 ifOlderThanTimeInterval:kMaxJsonsDurationTime currentDate:currentDate calendar:calendar];
                                }
                            }
                        }
                    }
                    else if (fileExistsAtPath2 && !isDirectory2) {
                        
                        if ([item2 isEqualToString:@"info.json"] || [item2 isEqualToString:@"theaters.json"]) {
                            [self deleteFileAtPath:itemPath2 ifOlderThanTimeInterval:kMaxJsonsDurationTime currentDate:currentDate calendar:calendar];
                        }
                    }
                }
            }
        }
        else if (fileExistsAtPath && !isDirectory) {
            // billboard.json or comingsoon.json
            if ([item isEqualToString:@"comingsoon.json"] || [item isEqualToString:@"billboard.json"]) {
                [self deleteFileAtPath:itemPath ifOlderThanTimeInterval:kMaxJsonsDurationTime currentDate:currentDate calendar:calendar];
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

@end
