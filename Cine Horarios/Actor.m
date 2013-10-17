//
//  Actor.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 13-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Actor.h"

@implementation Actor

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    _character = [attributes valueForKey:@"character"];
    if (!_character) {
        _character = @"";
    }
    
    return self;
}

@end
