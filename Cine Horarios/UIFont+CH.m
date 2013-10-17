//
//  UIFont+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIFont+CH.h"

@implementation UIFont (CH)

+(UIFont *)getSizeForCHFont:(CHFontStyle)cHFontStyle forPreferedContentSize:(NSString *)preferedContentSize {
    CGFloat fontSize;
    NSString *fontName = @"HelveticaNeue-Light";
    
    switch (cHFontStyle) {
        case CHFontStyleSmaller:
            fontSize = 15;
            break;
        case CHFontStyleSmall:
            fontSize = 16;
            break;
        case CHFontStyleNormal:
            fontSize = 17;
            break;
        case CHFontStyleBig:
            fontSize = 18;
            break;
        case CHFontStyleBigger:
            fontSize = 19;
            break;
        case CHFontStyleSmallerBold:
            fontSize = 15;
            fontName = @"HelveticaNeue";
            break;
        case CHFontStyleSmallBold:
            fontSize = 16;
            fontName = @"HelveticaNeue";
            break;
        case CHFontStyleNormalBold:
            fontSize = 17;
            fontName = @"HelveticaNeue";
            break;
        case CHFontStyleBigBold:
            fontSize = 18;
            fontName = @"HelveticaNeue";
            break;
        case CHFontStyleBiggerBold:
            fontSize = 19;
            fontName = @"HelveticaNeue";
            break;
        default:
            fontSize = 17;
            break;
    }
    
    if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
        fontSize -= 3;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategorySmall]) {
        fontSize -= 2;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryMedium]) {
        fontSize -= 1;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
        fontSize += 1;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        fontSize += 2;
    }
    else if ([preferedContentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        fontSize += 3;
    }
    return [self fontWithName:fontName size:fontSize];
}

@end
