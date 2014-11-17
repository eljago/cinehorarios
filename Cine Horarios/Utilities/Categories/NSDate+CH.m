//
//  NSDate+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "NSDate+CH.h"

@implementation NSDate (CH)

-(NSString *) getShortDateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"%a %e"];
    return [formatter stringFromDate:self];
}

@end
