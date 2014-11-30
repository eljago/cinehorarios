//
//  GFKInterface.h
//  GeoDemo
//
//  Created by Daniel on 11/3/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFKDao.h"
#import "Anuncios.h"
#import "Encontrado.h"
#import "PromocionViewController.h"
#import "Faro.h"
#import "Inicio.h"


@interface GFKInterface : NSObject


+ (GFKInterface *)sharedGFKInterface;

@property GFKDao *dao;

- (NSArray*)listaAnunciosGuardados;

- (BOOL)borrarAnuncio:(Anuncios*)anuncio;

- (NSArray*)listaEncontrados;

- (void)setAsNil:(Encontrado*)enc;

- (PromocionViewController*)viewControllerPara:(Anuncios*)anuncio;

- (void)agregarFaro:(NSString*)identificador;

- (NSArray*)listaFaros;

- (void)agregarInicio;
- (NSArray*)listaInicios;

-(void)cambiarEstado:(BOOL)estado aEncontrado:(Encontrado*)encontrado;

- (void)trucheria;
@end
