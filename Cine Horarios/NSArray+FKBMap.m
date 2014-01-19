//
//  NSArray+FKBMap.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "NSArray+FKBMap.h"

@implementation NSArray (FKBMap)

- (NSArray *)fkbMap:(id (^)(id inputItem))transformBlock {
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id item in self) {
        id newItem = transformBlock(item);
        [newArray addObject:newItem];
    }
    
    return [NSArray arrayWithArray:newArray];
}
@end
