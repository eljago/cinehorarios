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
#import "REMenu.h"

@interface InitialVC ()
@property (nonatomic, strong) REMenu *menu;
@end

@implementation InitialVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = @"CinesVC";
    }
    
    GlobalNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in menuArray) {
        NSString *name = dict[@"name"];
        UIImage *image = [[UIImage imageNamed:dict[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        NSString *storyboardID = dict[@"storyboardID"];
        
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:name image:image highlightedImage:image action:^(REMenuItem *item) {
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:storyboardID]];
        }];
        [menuItems addObject:item];
    }
    self.menu = [[REMenu alloc] initWithItems:[NSArray arrayWithArray:menuItems]];
    [self.menu showFromNavigationController:self.navigationController];
    
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
    return [self.navigationController.topViewController supportedInterfaceOrientations];
}

@end
