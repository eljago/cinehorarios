//
//  UIViewController+CHMenu.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 12-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class DoAlertView;

@interface UIViewController (DoAlertView) <ADBannerViewDelegate>

- (DoAlertView *) getDoAlertView;
- (void) alertWithTitle:(NSString *)title body:(NSString *)body completeBlock:(void (^)())completeBlock;
- (void) alertRetryWithCompleteBlock:(void (^)())completeBlock;

@end
