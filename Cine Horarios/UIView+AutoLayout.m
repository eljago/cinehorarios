//
//  UIView+AutoLayout.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)addVisualConstraints:(NSString*)constraintString forViews:(NSDictionary*)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                 options:0
                                                                 metrics:0
                                                                   views:views]];
}

@end
