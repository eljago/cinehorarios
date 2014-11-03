//
//  Video.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Video.h"
#import "BasicMovie.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation Video

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageURL": @"image_url",
             @"videoType": @"video_type",
             @"movie": @"show"
             };
}

+ (NSValueTransformer *)movieJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:BasicMovie.class];
}

@end
