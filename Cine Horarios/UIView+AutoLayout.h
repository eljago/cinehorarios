//
//  UIView+AutoLayout.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)
- (void)addVisualConstraints:(NSString*)constraintString forViews:(NSDictionary*)views;
@end
