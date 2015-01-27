//
//  MovieCell3+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellCast.h"

@interface MovieCellCast (Movie)

- (void)configureForActors:(NSArray *)actors font:(UIFont *)font;
+ (CGFloat) heightForRow;

@end
