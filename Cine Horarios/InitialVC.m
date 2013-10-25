//
//  InitialVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "InitialVC.h"

@interface InitialVC ()

@end

@implementation InitialVC


- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    self.backgroundImage = [UIImage imageNamed:@"MenuBackground"];
    self.panGestureEnabled = NO;
}

#pragma mark - Preferred Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Supported Orientations

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.contentViewController supportedInterfaceOrientations];
}

@end
