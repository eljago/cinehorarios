//
//  BasicCell+Theater.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicCell+Theater.h"

@implementation BasicCell (Theater)

-(void) configureForTheater:(Theater2 *)theater {
    self.mainLabel.text = theater.name;
}

@end
