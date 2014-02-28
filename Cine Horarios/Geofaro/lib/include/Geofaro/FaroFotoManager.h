//
//  FaroFotoManager.h
//  Geofaro
//
//  Created by Hernán Beiza on 6/5/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FaroFotoManager;
@protocol FaroFotoManagerDelegate <NSObject>
@required
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargandoProgreso:(NSInteger)progreso;
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargadaCompletada:(UIImage*)imagen;
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargadaError:(NSError*)error;
@end

@interface FaroFotoManager : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (retain) id delegate;
@property (nonatomic) BOOL esNuevo;

+ (FaroFotoManager *)sharedFaroFotoManager;
- (void)cargarImagenRuta:(NSString *)rutaImagen;
- (void)detenerCarga;
- (BOOL)borrarImagenesCarpetaNombre:(NSString *)nombre;
- (BOOL)borrarImagenRuta:(NSString*)ruta;
@end

