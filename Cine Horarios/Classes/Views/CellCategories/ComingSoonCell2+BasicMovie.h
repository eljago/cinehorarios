//
//  ComingSoonCell+BasicMovie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonCell2.h"

@class BasicMovie;

@interface ComingSoonCell2 (BasicMovie)

- (void) configureForBasicMovie:(BasicMovie *)basicMovie;
+ (CGFloat) heightForRowWithBasicMovie:(BasicMovie *)basicMovie headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont;

@end