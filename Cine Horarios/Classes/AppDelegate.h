//
//  AppDelegate.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
