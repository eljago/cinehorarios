//
//  AppDelegate+Geofaro.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 27-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate.h"

#import <GeoFaroKit/GFKManager.h>
#import <GeoFaroKit/GFKManagerOptions.h>
#import <GeoFaroKit/PromocionViewController.h>
#import <GeoFaroKit/GFKInterface.h>

#import "Reachability.h"
#import "Geofaro.h"

@interface AppDelegate (Geofaro) <GeoFaroKitProtocol,GeofaroDelegate>

- (void)setMiGeofaro:(Geofaro *)miGeofaro;
- (Geofaro *)miGeofaro;

- (void)setMiLaunchOptions:(NSDictionary *)miLaunchOptions;
- (NSDictionary *)miLaunchOptions;

- (void)setMiNotificationsOptions:(NSDictionary *)miNotificationsOptions;
- (NSDictionary *)miNotificationsOptions;

- (void)geofaroApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)geofaroApplicationDidEnterBackground:(UIApplication *)application;
- (void)geofaroApplicationWillEnterForeground:(UIApplication *)application;


-(void)reachabilityChanged:(NSNotification*)note;

@end
