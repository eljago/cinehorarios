//
//  NSArray+FKBMap.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FKBMap)

- (NSArray *)fkbMap:(id (^)(id inputItem))transformBlock;

@end
