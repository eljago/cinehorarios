//
//  MovieCell5+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellImages.h"

@interface MovieCellImages (Movie)

- (void)configureForImages:(NSArray *)images;
+ (CGFloat) heightForRow;

@end
