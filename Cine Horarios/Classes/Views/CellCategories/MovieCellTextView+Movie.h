//
//  MovieCell1+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellTextView.h"
@class Movie;

@interface MovieCellTextView (Movie)

- (void)configureSynpsisForMovie:(Movie *)movie;
- (void)configureMovieInfoForMovie:(Movie *)movie boldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont;
- (CGFloat) heightForRowWithFont:(UIFont *)font;
- (CGFloat) heightForAttributedTextView;

@end
