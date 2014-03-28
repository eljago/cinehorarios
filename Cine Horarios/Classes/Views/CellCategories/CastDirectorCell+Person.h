//
//  CastDirectorCell+Person.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastDirectorCell.h"

@class Person;

@interface CastDirectorCell (Person)

- (void) configureForPerson:(Person *) person;
+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName;

@end
