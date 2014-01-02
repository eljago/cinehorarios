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
    view.backgroundColor = [UIColor tableViewColor];
//    view.alpha = 0.85;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, height)];
    label.textColor = [UIColor blackColor];
    label.tag = 40;
    label.font = font;
    label.text = text;
    [view addSubview: label];
    return view;
}
@end
