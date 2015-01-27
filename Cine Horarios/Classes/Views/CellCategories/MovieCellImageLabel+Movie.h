//
//  MovieCell2+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellImageLabel.h"
@class Movie;

@interface MovieCellImageLabel (Movie)

- (void) configureVideosCellForMovie:(Movie *)movie;
- (void) configureShowtimesCellForMovie:(Movie *)movie;
+ (CGFloat) heightForRow;

@end
