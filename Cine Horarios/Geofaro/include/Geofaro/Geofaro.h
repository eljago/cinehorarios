//
//  Geofaro.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/1/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Radar.h"
#import "Faro.h"

#import "PromocionGeoViewController.h"
#import "PromocionGeoiPadViewController.h"

#import "AlertaGeoView.h"

@class Geofaro;
@protocol GeofaroDelegate <NSObject>
@required
- (void)geofaro:(Geofaro*)geofaro faroEncontrado:(NSDictionary*)faroInfo;
- (void)geofaro:(Geofaro*)geofaro faroEncontradoNuevo:(NSDictionary*)faroInfo;
- (void)geofaro:(Geofaro*)geofaro faroEncontradoPromocionViewController:(UIViewController*)promocionViewController;
@end

@interface Geofaro : NSObject <RadarDelegate,FaroDelegate>

@property (retain) id delegate;
@property (nonatomic,strong) NSString *ud;
@property (nonatomic) BOOL notificaciones;
@property (nonatomic) BOOL alertaPower;

@property (nonatomic,strong) NSString *notificacionBotonCancel;
@property (nonatomic,strong) NSString *notificacionTituloPromocion;
@property (nonatomic,strong) NSString *notificacionMensajePromocion;
@property (nonatomic,strong) NSDictionary *launchOptions;

@property (nonatomic,strong) PromocionGeoViewController *promocionViewController;
@property (nonatomic,strong) PromocionGeoiPadViewController *promocioniPadViewController;

@property (nonatomic,strong) UIImage *errorImage;
@property (nonatomic) BOOL flagOcultarBarraStatus;

+ (Geofaro *)sharedGeofaro;
- (void)iniciar;
- (void)detener;

#pragma mark - Métodos Útiles
- (NSArray *)promociones;

#pragma mark - CuponesGeoviewController
- (UINavigationController *)cuponesGeoNavigationViewController;
- (UIViewController *)cuponesGeoViewController;

@end