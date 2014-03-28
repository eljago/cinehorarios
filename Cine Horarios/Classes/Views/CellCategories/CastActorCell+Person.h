//
//  CastActorCell+Actor.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastActorCell.h"

@class Person;

@interface CastActorCell (Person)

- (void) configureForPerson:(Person *) person;
+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName fontRole:(UIFont *)fontRole;

@end
