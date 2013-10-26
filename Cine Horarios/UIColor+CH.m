//
//  UIColor+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-07-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIColor+CH.h"

@implementation UIColor (CH)

+ (UIColor *)navColor{
    return [UIColor colorWithRed:186./255. green:62./255. blue:53./255. alpha:1.f];
}
+ (UIColor *)lighterNavColor{
    return [UIColor colorWithRed:186./255. green:62./255. blue:53./255. alpha:.9f];
}
+ (UIColor *)alizarin{
    return [UIColor colorWithRed:231./255. green:76./255. blue:60./255. alpha:1.f];
}
+ (UIColor *)pomegranate{
    return [UIColor colorWithRed:192./255. green:57./255. blue:43./255. alpha:1.f];
}
+ (UIColor *)lighterGrayColor{
    return [UIColor colorWithWhite:0.960 alpha:1.000];
}
+ (UIColor *)belizeHole{
    return [UIColor colorWithRed:41./225. green:128./225. blue:185./225. alpha:1.];
}
+ (UIColor *)darkerMidnightBlue {
    return [UIColor colorWithRed:32.f/255.f green:45.f/255.f blue:58.f/255.f alpha:1.f];
}
+ (UIColor *)midnightBlue {
    return [UIColor colorWithRed:44.f/255.f green:62.f/255.f blue:80.f/255.f alpha:1.f];
}
+ (UIColor *)wetAsphalt {
    return [UIColor colorWithRed:52.f/255.f green:73.f/255.f blue:94.f/255.f alpha:1.f];
}
+ (UIColor *)tableViewColor {
    return [UIColor colorWithRed:241.f/255.f green:234.f/255.f blue:227.f/255.f alpha:1.f];
}
+ (UIColor *)darkerNavColor {
    return [UIColor colorWithRed:115.f/225.f green:19.f/225.f blue:16.f/225.f alpha:1.f];
}
+(UIColor *)navUnselectedColor {
    return [UIColor colorWithWhite:0.667 alpha:0.4];
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];

    return color;
}

@end
