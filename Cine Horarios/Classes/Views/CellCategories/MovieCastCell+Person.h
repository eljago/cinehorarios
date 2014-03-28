//
//  MovieCastCell+MovieCast.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCastCell.h"

@class Person;

@interface MovieCastCell (Person)

- (void) configureForPerson:(Person *) person font:(UIFont *) font;

@end
