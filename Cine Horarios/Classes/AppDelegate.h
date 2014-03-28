//
//  AppDelegate.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "GAI.h"

#import "Geofaro.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeofaroDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;


@property (strong, nonatomic) Geofaro *miGeofaro;
@property (strong, nonatomic) NSDictionary *miLaunchOptions;
@property (nonatomic,strong) NSDictionary *miNotificationsOptions;

@end
