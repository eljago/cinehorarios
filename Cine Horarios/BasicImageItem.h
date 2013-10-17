//
//  BasicImageItem.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicItem.h"

@interface BasicImageItem : BasicItem

@property (nonatomic, readonly) NSString *imageUrl;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithId:(NSUInteger)itemId name:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
