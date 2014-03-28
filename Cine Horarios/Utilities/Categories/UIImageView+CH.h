//
//  UIImageView+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface UIImageView (CH)

+ (NSString *) imageURLForPath:(NSString *)imageURL imageType:(MovieImageType)movieImageType;

- (void) setImageWithStringURL:(NSString *)imageURL
                movieImageType:(MovieImageType) movieImageType
              placeholderImage:(UIImage *)placeholderImage;
- (void) setImageWithStringURL:(NSString *)imageURL
                movieImageType:(MovieImageType) movieImageType;

@end
