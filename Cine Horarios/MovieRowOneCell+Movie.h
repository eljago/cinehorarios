//
//  MovieRowOneCell+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-03-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieRowOneCell.h"

@interface MovieRowOneCell (Movie)

- (void) configurePortraitWithURL:(NSString *)portraitImageURL coverWithURL:(NSString *)coverImageURL;
- (void) configureForMovie:(Movie *)movie;
+ (CGFloat) heightForRowWithMovie:(Movie *)movie font:(UIFont *)font;

@end
