//
//  UIViewController+CHMenu.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 12-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIViewController+DoAlertView.h"
#import <objc/runtime.h>
#import "DoAlertView.h"

@implementation UIViewController (DoAlertView)

- (DoAlertView *) getDoAlertView
{
    if (objc_getAssociatedObject(self, @"doalertview")==nil)
    {
        DoAlertView *alert = [[DoAlertView alloc] init];
        alert.nAnimationType = DoTransitionStylePop;
        alert.dRound = 2.0;
        alert.bDestructive = NO;
        
        objc_setAssociatedObject(self,@"doalertview",alert,OBJC_ASSOCIATION_RETAIN);
    }
    return (DoAlertView *)objc_getAssociatedObject(self, @"doalertview");
}

#pragma mark Alerts

-(void) alertWithTitle:(NSString *)title body:(NSString *)body completeBlock:(void (^)())completeBlock {
    self.getDoAlertView.hidden = NO;
    [self.getDoAlertView doYesNo:title body:body yes:^(DoAlertView *alertView) {
        self.getDoAlertView.hidden = YES;
        completeBlock();
    } no:^(DoAlertView *alertView) {
        self.getDoAlertView.hidden = YES;
    }];
}
-(void) alertRetryWithCompleteBlock:(void (^)())completeBlock {
    self.getDoAlertView.hidden = NO;
    [self.getDoAlertView doYesNo:@"Problema de Conexión" body:@"¿Reintentar?" yes:^(DoAlertView *alertView) {
        self.getDoAlertView.hidden = YES;
        completeBlock();
    } no:^(DoAlertView *alertView) {
        self.getDoAlertView.hidden = YES;
    }];
}

@end
