//
//  BasicItem.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

@interface BasicItem : NSObject

@property (nonatomic, readonly) NSUInteger itemId;
@property (nonatomic, readonly) NSString *name;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithId:(NSUInteger)itemId name:(NSString *)name;
- (id)initWithName:(NSString *)name;
@end
