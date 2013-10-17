//
//  SwatchTransition.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "SwatchTransition.h"

const CGFloat SWATCH_PRESENT_DURATION = 1.5;

@implementation SwatchTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return SWATCH_PRESENT_DURATION;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
//    CGRect initialTargetFrame = [transitionContext initialFrameForViewController:toVC];
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(- M_PI / 2);
    toVC.view.layer.anchorPoint = CGPointZero;
    toVC.view.frame = sourceRect;
    toVC.view.transform = rotation;
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    
    [UIView animateWithDuration:SWATCH_PRESENT_DURATION delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
