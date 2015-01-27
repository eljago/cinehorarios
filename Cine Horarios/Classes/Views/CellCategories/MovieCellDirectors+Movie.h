//
//  MovieCell4+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellDirectors.h"

@interface MovieCellDirectors (Movie)

- (void) configureCellForDirectors:(NSArray *)directors;
+ (CGFloat) heightForRowWithFont:(UIFont *)font directors:(NSArray *)directors;

@end
