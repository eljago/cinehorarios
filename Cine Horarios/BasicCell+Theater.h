//
//  BasicCell+Theater.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicCell.h"
#import "Theater2.h"

@interface BasicCell (Theater)

- (void) configureForTheater:(Theater2 *)theater;

@end
