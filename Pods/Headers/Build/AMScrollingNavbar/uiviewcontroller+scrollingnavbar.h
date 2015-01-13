//
//  UIViewController+ScrollingNavbar.h
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

@interface UIViewController (ScrollingNavbar) <UIGestureRecognizerDelegate>

/**-----------------------------------------------------------------------------
 * @name UIViewController+ScrollingNavbar
 * -----------------------------------------------------------------------------
 */

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Also sets the value (in points) that needs to scroll through beofre the navbar is moved back into scene
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param delay The delay of the downward scroll gesture
 */
- (void)followScrollView:(UIView*)scrollableView withDelay:(float)delay;

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 */
- (void)followScrollView:(UIView*)scrollableView;

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * This method also hides and shows a given UIToolbar in the bottom of the screen.
 * Remember to call showNavbar or showNavBarAnimated: in your viewWillDisappear and refreshNavbar in viewWillAppear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param constraint The UIToolbar's NSLayoutConstraint that will be manipulated to hide the bar in the bottom alongside tha navigation bar
 */
- (void)followScrollView:(UIView*)scrollableView withToolbarConstraint:(NSLayoutConstraint*)constraint;

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Also sets the value (in points) that needs to scroll through beofre the navbar is moved back into scene
 * This method also hides and shows a given UIToolbar in the bottom of the screen.
 * Remember to call showNavbar or showNavBarAnimated: in your viewWillDisappear and refreshNavbar in viewWillAppear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param constraint The UIToolbar's NSLayoutConstraint that will be manipulated to hide the bar in the bottom alongside tha navigation bar
 * @param delay The delay of the downward scroll gesture
 */
- (void)followScrollView:(UIView*)scrollableView withToolbarConstraint:(NSLayoutConstraint*)constraint withDelay:(float)delay;

/** Navbar slide down
 *
 * Manually show the navbar
 */
- (void)showNavbar;

/** Navbar slide down
 *
 * Manually show the navbar
 *
 * @param animated Animates the navbar scrolling
 */
- (void)showNavBarAnimated:(BOOL)animated;

/** Remove the scrollview tracking
 *
 * Use this method to stop following the navbar
 */
- (void)stopFollowingScrollView;

/** Enable or disable the scrolling
 *
 * Set this property to NO to disable the scrolling of the navbar.
 */
- (void)setScrollingEnabled:(BOOL)enabled;

@end