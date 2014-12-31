//
//  FunctionsTableView.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 31-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsTableView.h"

@interface FunctionsTableView () <UIGestureRecognizerDelegate>

@end

@implementation FunctionsTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ) {
        return NO;
    }
    return YES;
}

@end
