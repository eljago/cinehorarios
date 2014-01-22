//
//  FunctionCell2+Function.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionCell2.h"

@class Function2;

@interface FunctionCell2 (Function2)

- (void) configureForFunction:(Function2 *) function;
+ (CGFloat) heightForRowWithFunction:(Function2 *)function headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont;

@end
