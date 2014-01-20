//
//  BillboardCell+BasicMovie.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BillboardCell.h"

@class BasicMovie2;

@interface BillboardCell (BasicMovie)

- (void) configureForBasicMovie:(BasicMovie2 *)basicMovie;
+ (CGFloat) heightForRowWithBasicMovie:(BasicMovie2 *)basicMovie headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont;

@end
