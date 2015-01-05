//
//  GFKComm.h
//  GeoDemo
//
//  Created by Daniel on 10/20/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GFKDao.h"
#import "Encontrado.h"
#import "GFKManagerOptions.h"
#import <UIKit/UIKit.h>
#import "PromocionViewController.h"
#import "Anuncios.h"
#import "Fechas.h"
#import "Errores.h"
#import "GFKCommunications.h"


@protocol GeoFaroKitProtocol <NSObject>

@optional

-(void)mostrarPromocionViewControllerConAnuncio:(PromocionViewController*)pvc;

@end

@interface GFKComm : NSObject<NSURLSessionDelegate,NSXMLParserDelegate>


@property GFKManagerOptions *opcionesConfiguracion;

@property id<GeoFaroKitProtocol> delegate;

@property NSMutableDictionary *dk;
@property NSMutableString *str;

@property BOOL __block flagEnviando;
@property int j;
@property int k;

@property BOOL __block flagProceso;
@property BOOL __block flagCola;
@property NSString *ultimo;

@property NSString *ultimoIdentificador;

@property Encontrado *encontrado;

@property dispatch_semaphore_t semaphore;


- (void)conConfiguracion:(GFKManagerOptions*)opciones;
- (void)encontroBeacon:(CLBeacon*)beacon;
- (void)encontroZona:(NSString*)identificador;
- (void)ingresarACola:(NSString*)identificador;
- (void)reiniciarCola;
- (void)cambiarFlagProceso;
- (OSStatus) extractIdentityAndTrust:(CFDataRef)infdata identity:(SecIdentityRef *)identity trust:(SecTrustRef *)trust;
@end
