//
//  Cast.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Cast.h"

@implementation Cast

-(id)initWithDirectors:(NSArray *)directors actors:(NSArray *)actors {
    self = [super init];
    if (self) {
        _directors = directors;
        _actors = actors;
    }
    return self;
}
@end