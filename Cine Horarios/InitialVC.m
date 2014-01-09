//
//  InitialVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "InitialVC.h"
#import "GlobalNavigationController.h"
#import "MenuVC.h"

@interface InitialVC ()

@end

@implementation InitialVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = @"CinesVC";
    }
    
    GlobalNavigationController *navigationController = (GlobalNavigationController *)self.topViewController;
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    navigationController.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:navigationController action:@selector(revealMenu:)];
    MenuVC *menuVC = (MenuVC *)self.underLeftViewController;
    menuVC.startingVCID = identifier;
    
    [navigationController.navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setShadowImage:[UIImage new]];
}

//#pragma mark - Preferred Status Bar Style
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - Supported Orientations

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
