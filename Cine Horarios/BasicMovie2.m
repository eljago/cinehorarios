//
//  BasicMovie2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicMovie2.h"
#import "CineHorariosApiClient.h"
#import "MTLValueTransformer.h"

@implementation BasicMovie2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"portraitImageURL": @"portrait_image",
             @"imageURL": @"image_url"
             };
}


@end
