//
//  MovieCellRating+Movie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 25-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellRating.h"

@interface MovieCellRating (Movie)

- (void)configureForRating:(NSString *)score image:(UIImage *)image webpageName:(NSString *)webpageName;
+ (CGFloat) heightForRow;

@end
