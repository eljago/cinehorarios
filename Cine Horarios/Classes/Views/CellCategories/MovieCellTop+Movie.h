//
//  MovieCell0+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellTop.h"
@class Movie;

@interface MovieCellTop (Movie)

- (void)configureForMovie:(Movie *)movie coverImageURL:(NSString *)coverImageURL portraitImageURL:(NSString *)portraitImageURL;
+ (CGFloat) heightForRow;

@end
