//
//  BasicImageItem.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicImageItem.h"

@implementation BasicImageItem

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    _imageUrl = [attributes valueForKeyPath:@"image_url"];
    
    return self;
}
- (id)initWithId:(NSUInteger)itemId name:(NSString *)name imageUrl:(NSString *)imageUrl {
    self = [super initWithId:itemId name:name];
    if (!self) {
        return nil;
    }
    _imageUrl = imageUrl;
    
    return self;
}

@end
