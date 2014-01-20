//
//  MTLModelPersistable.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLModel+NSCoding.h"
#import "NSFileManager+CH.h"

@implementation MTLModelPersistable

- (void)persistToFile:(NSString *)filePath
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (id)loadFromPath:(NSString *)path
{
    id item = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && ![NSFileManager isFileOldWithPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        item = [[[self class] alloc] initWithCoder:unarchiver];
        [unarchiver finishDecoding];
    }
    return item;
}

@end
