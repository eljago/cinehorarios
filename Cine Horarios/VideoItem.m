//
//  VideoItem.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 17-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    
    _code = [attributes valueForKey:@"code"];
    
    return self;
}

@end
