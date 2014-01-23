//
//  BasicItem2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicItem2.h"
#import "BasicItemImage.h"

@implementation BasicItem2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemID": @"id"
             };
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    
    if (JSONDictionary[@"image_url"] != nil) {
        return BasicItemImage.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end
