//
//  NSFileManager+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (CH)

+(BOOL)isFileOldWithPath:(NSString *)path;
+ (NSString *)storagePathForPath:(NSString *)path;

@end
