//
//  UIFont+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIFont+CH.h"

//NSString *const kHelveticaNeue = @"Avenir-Book";
NSString *const kHelveticaNeue = @"ProximaNova-Light";
NSString *const kHelveticaNeueBold = @"ProximaNova-Regular";

@implementation UIFont (CH)

+(UIFont *)getSizeForCHFont:(CHFontStyle)cHFontStyle forPreferedContentSize:(NSString *)preferedContentSize {
    CGFloat fontSize = 19.;
    NSString *fontName;
    
    switch (cHFontStyle) {
        case CHFontStyleSmaller:
            fontSize -= 2;
            fontName = kHelveticaNeue;
            break;
        case CHFontStyleSmall:
            fontSize -= 1;
            fontName = kHelveticaNeue;
            break;
        case CHFontStyleNormal:
            fontName = kHelveticaNeue;
            break;
        case CHFontStyleBig:
            fontSize += 1;
            fontName = kHelveticaNeue;
            break;
        case CHFontStyleBigger:
            fontSize += 2;
            fontName = kHelveticaNeue;
            break;
        case CHFontStyleSmallerBold:
            fontSize -= 2;
            fontName = kHelveticaNeueBold;
            break;
        case CHFontStyleSmallBold:
            fontSize -= 1;
            fontName = kHelveticaNeueBold;
            break;
        case CHFontStyleNormalBold:
            fontName = kHelveticaNeueBold;
            break;
        case CHFontStyleBigBold:
            fontSize += 1;
            fontName = kHelveticaNeueBold;
            break;
        case CHFontStyleBiggerBold:
            fontSize += 2;
            fontName = kHelveticaNeueBold;
            break;
        default:
            break;
    }
    
    if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
        fontSize -= 3.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategorySmall]) {
        fontSize -= 2.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryMedium]) {
        fontSize -= 1.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
        fontSize += 1.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        fontSize += 2.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        fontSize += 3.;
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

+(UIFont *)getFontWithName:(NSString *)fontName forPreferedContentSize:(NSString *)preferedContentSize {
    CGFloat fontSize = 19.;
    
    if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
        fontSize -= 3.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategorySmall]) {
        fontSize -= 2.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryMedium]) {
        fontSize -= 1.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
        fontSize += 1.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        fontSize += 2.;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        fontSize += 3.;
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
