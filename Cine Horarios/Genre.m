//
//  Genre.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Genre.h"

@implementation Genre

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"genreID": @"id"
             };
}

@end
