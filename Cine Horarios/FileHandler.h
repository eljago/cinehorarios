//
//  FileHandler.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CitiesVC;
@class TheatersVC;
@class FuncionesVC;


@interface FileHandler : NSObject

+ (NSDictionary *) getDictionaryInProjectNamed: (NSString *) plistName;

+ (void) removeOldImages;
+ (void) removeOldJsons;

+ (NSString *)getFullLocalPathForPath:(NSString *)path fileName:(NSString *)fileName;
+ (void)getMenuDictsAndSelectedIndex:(void (^)(NSArray *menuDicts, NSInteger selectedIndex))block withStoryboardID:(NSString *)identifier;
@end
