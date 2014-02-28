//
//  GPS.h
//  DemoFaro
//
//  Created by Hernan on 12/12/12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "Faro.h"
@class Radar;
@protocol RadarDelegate <NSObject>
@required
- (void)radar:(Radar*)radar faroEncontrado:(NSDictionary*)faroInfo;
- (void)radar:(Radar*)radar faroEncontradoNuevo:(NSDictionary*)faroInfo;
@end

@interface Radar : NSObject <CLLocationManagerDelegate,FaroDelegate>

@property (retain) id delegate;

@property (nonatomic,retain) Faro *faro;

@property (nonatomic) float distanciaMinima;
@property (nonatomic,strong) CLLocation *ubicacionActual;
@property (nonatomic,strong) CLLocation *ubicacionFinal;

+ (Radar *)sharedRADAR;
- (void)iniciar;
- (void)iniciarRegiones:(NSMutableArray*)regiones;
- (void)iniciarGPSUbicacion:(CLLocation*)ubicacion;
- (void)detenerRadar;
@end