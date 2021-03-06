//
//  UIColor+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-07-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIColor+CH.h"

#define DO_RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DO_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation UIColor (CH)

+ (UIColor *)navColor{
    return DO_RGB(168, 56, 48);
}
+ (UIColor *)alizarin{
    return DO_RGB(231, 76, 60);
}
+ (UIColor *)amethyst{
    return DO_RGB(155, 89, 182);
}
+ (UIColor *)pomegranate{
    return DO_RGB(192, 57, 43);
}
+ (UIColor *)lighterGrayColor{
    return [UIColor colorWithWhite:0.960 alpha:1.000];
}
+ (UIColor *)belizeHole{
    return DO_RGB(41, 128, 185);
}
+ (UIColor *)peterRiver{
    return DO_RGB(52, 152, 219);
}
+ (UIColor *)orange{
    return DO_RGB(243, 156, 18);
}
+ (UIColor *)orange2{
    return DO_RGB(231, 146, 27);
}
+ (UIColor *)carrot{
    return DO_RGB(230, 126, 34);
}
+ (UIColor *)pumpkin{
    return DO_RGB(211, 84, 0);
}
+ (UIColor *)greenSea{
    return DO_RGB(22, 160, 133);
}
+ (UIColor *)darkerMidnightBlue {
    return DO_RGB(32, 45, 58);
}
+ (UIColor *)midnightBlue {
    return DO_RGB(44, 62, 80);
}
+ (UIColor *)midnightBlueLight {
    return DO_RGBA(44, 62, 80, 0.7);
}
+ (UIColor *)wetAsphalt {
    return DO_RGB(52, 73, 94);
}
+ (UIColor *)wisteria {
    return DO_RGB(142, 68, 173);
}
+ (UIColor *)asbestos {
    return DO_RGB(127, 140, 141);
}
+ (UIColor *)concrete {
    return DO_RGB(149, 165, 166);
}
+ (UIColor *)tableViewColor {
    return DO_RGB(241, 234, 227);
}
+ (UIColor *)darkerNavColor {
    return DO_RGB(115, 19, 16);
}
+(UIColor *)navUnselectedColor {
    return [UIColor colorWithWhite:0.667 alpha:0.4];
}
+(UIColor *)orchidBouquet {
    return DO_RGB(229, 155, 215);
}
+(UIColor *)hydrangea {
    return DO_RGB(125, 94, 186);
}
+(UIColor *)grayYoutubeControls {
    return DO_RGB(60, 60, 60);
}
+(UIColor *)emerald {
    return DO_RGB(46, 204, 113);
}
+(UIColor *)nephritis {
    return DO_RGB(39, 174, 96);
}

+(UIColor *)menuColorForRow:(int)index {
    switch (index) {
        case 0:
            // Todos
            return [UIColor greenSea];
            break;
        case 1:
            // Favoritos
            return [UIColor alizarin];
            break;
        case 2:
            // Cercanos
            return [UIColor orange2];
            break;
        case 3:
            // Cartelera
            return [UIColor whiteColor];
            break;
        case 4:
            // Próximos Estrenos
            return [UIColor peterRiver];
            break;
        case 5:
            // Ajustes
            return [UIColor alizarin];
            break;
        case 6:
            // Ajustes
            return [UIColor brownColor];
            break;
        default:
            return [UIColor whiteColor];
            break;
    }
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];

    return color;
}

@end
