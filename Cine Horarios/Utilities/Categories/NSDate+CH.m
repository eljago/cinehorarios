//
//  NSDate+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "NSDate+CH.h"

@implementation NSDate (CH)

- (NSString *) getShortDateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"EEEE dd"];
    return [formatter stringFromDate:self];
}

- (NSDate *) datePlusDays:(NSInteger)days {
    return [[NSDate date] dateByAddingTimeInterval:60*60*24*days];
}

@end
