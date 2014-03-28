//
//  BasicCell+Theater.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicCell.h"

@class Theater;

@interface BasicCell (Theater)

- (void) configureForTheater:(Theater *)theater;
+ (CGFloat) heightForRowWithTheater:(Theater *)theater tableFont:(UIFont *)font;

@end
