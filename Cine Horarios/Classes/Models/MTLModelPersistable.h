//
//  MTLModelPersistable.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"

@interface MTLModelPersistable : MTLModel

@property (nonatomic, assign, readonly) NSUInteger storageDuration;

- (void)persistToFile:(NSString *)filePath;
+ (id)loadIfOlderThanThreeHoursFromPath:(NSString *)path;
+ (id)loadIfOlderThanOneWeekFromPath:(NSString *)path;
+ (NSString *)storagePathForPath:(NSString *)path;

@end
