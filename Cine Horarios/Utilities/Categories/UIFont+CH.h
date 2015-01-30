//
//  UIFont+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHFontStyle) {
    CHFontStyleSmallest,
    CHFontStyleSmaller,
    CHFontStyleSmall,
    CHFontStyleNormal,
    CHFontStyleBig,
    CHFontStyleBigger,
    CHFontStyleSmallestBold,
    CHFontStyleSmallerBold,
    CHFontStyleSmallBold,
    CHFontStyleNormalBold,
    CHFontStyleBigBold,
    CHFontStyleBiggerBold
};

@interface UIFont (CH)

+(UIFont *)getSizeForCHFont:(CHFontStyle)cHFontStyle forPreferedContentSize:(NSString *)preferedContentSize;
+(UIFont *)getFontWithName:(NSString *)fontName forPreferedContentSize:(NSString *)preferedContentSize;

@end
