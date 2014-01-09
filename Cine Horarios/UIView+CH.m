//
//  UIView+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 16-12-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIView+CH.h"
#import "UIColor+CH.h"

@implementation UIView (CH)

+ (UIView *) headerViewForText: (NSString *) text font: (UIFont *) font height: (CGFloat) height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, height)];
    view.backgroundColor = [UIColor navColor];
//    view.alpha = 0.85;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, height)];
    label.textColor = [UIColor whiteColor];
    label.tag = 40;
    label.font = font;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview: label];
    return view;
}
+(CGFloat) heightForHeaderViewWithText:(NSString *)text font:(UIFont *)font {
    CGSize size = CGSizeMake(300.f, 1000.f);
    
    CGRect nameLabelRect = [text boundingRectWithSize: size
                                                        options: NSStringDrawingUsesLineFragmentOrigin
                                                     attributes: [NSDictionary dictionaryWithObject:font
                                                                                             forKey:NSFontAttributeName]
                                                        context: nil];
    
    CGFloat totalHeight = nameLabelRect.size.height * 1.2;
    
    if (totalHeight <= 25.f) {
        totalHeight = 25.f;
    }
    
    return totalHeight;
}

@end
