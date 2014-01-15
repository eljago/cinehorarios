//
//  GlobalNavigationController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GlobalNavigationController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuVC.h"
#import "MEDynamicTransition.h"

@interface GlobalNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MEDynamicTransition *transition;
@end

@implementation GlobalNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transition.slidingViewController = self.slidingViewController;
    self.transitionPanGesture.delegate = self;
    
    self.slidingViewController.delegate = self.transition;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.transitionPanGesture];
    [self.navigationBar addGestureRecognizer:self.transitionPanGesture];
//    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
//    self.slidingViewController.customAnchoredGestures = @[];
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius  = 10.0f;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.view.layer.shadowPath    = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuVC class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.superview isKindOfClass:[UICollectionViewCell class]])
    {
        return NO;
    }
    else return YES;
}

#pragma mark - GlobalNavigationController
#pragma mark Properties
-(MEDynamicTransition *)transition {
    if (_transition) return _transition;
    _transition = [[MEDynamicTransition alloc] init];
    return _transition;
}
- (UIPanGestureRecognizer *)transitionPanGesture {
    if (_transitionPanGesture) return _transitionPanGesture;
    _transitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transition action:@selector(handlePanGesture:)];
    return _transitionPanGesture;
}

#pragma mark IBActions

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Supported Orientations

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
