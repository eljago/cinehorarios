//
//  GFKManager.h
//  GeoDemo
//
//  Created by Daniel on 10/14/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "GFKManagerOptions.h"
#import "GFKComm.h"
#import "GFKInterface.h"
#import "PromocionViewController.h"


static BOOL DEBUGo = YES;

@interface GFKManager : NSObject <CLLocationManagerDelegate, GeoFaroKitProtocol,NSURLSessionDelegate>

@property BOOL conexion;
@property GFKManagerOptions *opciones;

@property id<GeoFaroKitProtocol>delegate;
@property NSTimer *timer;

+ (instancetype)GeoFaroManager;
- (void)setOpciones:(GFKManagerOptions *)opciones;
- (BOOL)iniciarGeoFaroReporteError:(NSError**)error;
- (void)intentarConexionConEstado:(BOOL)con;


@end
