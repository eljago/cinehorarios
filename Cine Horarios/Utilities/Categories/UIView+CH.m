//
//  UIView+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 16-12-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIView+CH.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"

@implementation UIView (CH)

+ (UIView *)headerViewForText:(NSString *)text height:(CGFloat)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, height)];
    view.backgroundColor = [UIColor grayYoutubeControls];
//    view.alpha = 0.85;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, height)];
    label.textColor = [UIColor whiteColor];
    label.tag = 40;
    label.font = [UIFont getSizeForCHFont:CHFontStyleSmallerBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    label.text = [text uppercaseString];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview: label];
    label.center = view.center;
    CGRect frame = label.frame;
    frame.origin.y += 1;
    label.frame = frame;
    return view;
}
+ (CGFloat)heightForHeaderViewWithText:(NSString *)text {
    CGSize size = CGSizeMake(300.f, 1000.f);
    
    UIFont *font = [UIFont getSizeForCHFont:CHFontStyleSmallerBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    CGRect nameLabelRect = [[text uppercaseString] boundingRectWithSize: size
                                                        options: NSStringDrawingUsesLineFragmentOrigin
                                                             attributes: @{NSFontAttributeName: font}
                                                        context: nil];
    
    CGFloat totalHeight = nameLabelRect.size.height * 1.2;
    
    if (totalHeight <= 25.f) {
        totalHeight = 25.f;
    }
    
    return totalHeight;
}

@end
