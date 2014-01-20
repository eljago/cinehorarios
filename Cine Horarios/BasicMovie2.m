//
//  BasicMovie2.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicMovie2.h"
#import "CineHorariosApiClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"
#import "Genre.h"

@implementation BasicMovie2

+ (NSDateFormatter *)dateFormatter1 {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"];
    [dateFormatter1 setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    return dateFormatter1;
}
+ (NSDateFormatter *)dateFormatter2 {
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es-CL"];
    [dateFormatter2 setDateFormat:@"yyyy'-'MM'-'dd"];
    return dateFormatter2;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieID": @"id",
             @"portraitImageURL": @"portrait_image",
             @"imageURL": @"image_url"
             };
}

+ (NSValueTransformer *)genresJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Genre.class];
}
+ (NSValueTransformer *)debutJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *debut) {
        return [[BasicMovie2 dateFormatter1] stringFromDate:[[BasicMovie2 dateFormatter2] dateFromString:debut]];
    } reverseBlock:^(NSString *debut) {
        return [[BasicMovie2 dateFormatter2] stringFromDate:[[BasicMovie2 dateFormatter1] dateFromString:debut]];
    }];
}


@end
