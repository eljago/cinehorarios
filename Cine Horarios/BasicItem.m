//
//  BasicItem.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicItem.h"

@implementation BasicItem

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    _itemId = [[attributes valueForKey:@"id"] integerValue];
    _name = [attributes valueForKey:@"name"];
    
    return self;
}

- (id)initWithId:(NSUInteger)itemId name:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemId = itemId;
    _name = name;
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = name;
    
    return self;
}

@end
