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

typedef enum {
    MovieImageTypeCover,
    MovieImageTypePortrait,
    MovieImageTypeMovieImageCover,
    MovieImageTypeMovieImageFullScreenRetina,
    MovieImageTypeMovieImageFullScreenNoRetina,
    MovieImageTypeCastFullScreenRetina,
    MovieImageTypeCastFullScreenNoRetina,
    MovieImageTypeMovieVideo
} MovieImageType;


@interface FileHandler : NSObject

+ (NSDictionary *) getDictionaryInProjectNamed: (NSString *) plistName;

+ (void) removeOldImages;
+ (void) removeOldJsons;

+ (void) getImageForImageView:(UIImageView *) imageView
               usingImageURL:(NSString *)imageURL
              movieImageType:(MovieImageType) movieImageType
            placeholderImage:(UIImage *)placeholderImage;

+ (NSURL *) nsurlWithImagePath:(NSString *)imageURL imageType:(MovieImageType)movieImageType;
+ (NSString *) imageURLForPath:(NSString *)imageURL imageType:(MovieImageType)movieImageType;
+ (void) getImageForImageView:(UIImageView *) imageView
                usingImageURL:(NSString *)imageURL
               movieImageType:(MovieImageType) movieImageType;
+ (void) cancelDownloadOfImageView:(UIImageView *)imageView;

+ (NSString *)getFullLocalPathForPath:(NSString *)path fileName:(NSString *)fileName;
@end
