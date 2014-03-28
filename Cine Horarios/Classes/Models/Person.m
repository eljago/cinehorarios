//
//  Person.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageURL": @"image_url"
             };
}

@end
