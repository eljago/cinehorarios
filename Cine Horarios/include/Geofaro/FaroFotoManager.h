//
//  FaroFotoManager.h
//  Geofaro
//
//  Created by Hernán Beiza on 6/5/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FaroFotoManager;
/**
 *  Delegados de la FaroFotoManager
 */
@protocol FaroFotoManagerDelegate <NSObject>
@required
/**
 @abstract Delegado que se llama cuando la imagen se está bajando.
 @deprecated 1.68
 *
 @param faroFotoManager Instancia FaroFotoManager
 @param progreso        progreso en porcentaje de la carga
 */
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargandoProgreso:(NSInteger)progreso;
/**
 *  Delegado que se llama cuando la imagen se ha descargado completamente
 *
 *  @param faroFotoManager Instancia FaroFotoManager
 *  @param imagen          UIImage descargado
 */
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargadaCompletada:(UIImage*)imagen;
/**
 *  Delegado que se llama cuando hay un error con la descarga de la imagen
 *
 *  @param faroFotoManager Instancia FaroFotoManager
 *  @param error           NSError con la descripción del error
 */
- (void)faroFotoManager:(FaroFotoManager*)faroFotoManager fotoCargadaError:(NSError*)error;
@end
/**
 *  Clase que descarga la imagen del servidor
 */
@interface FaroFotoManager : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  Singleton de la clase
 *
 *  @return FaroFotoManager
 */
+ (FaroFotoManager *)sharedFaroFotoManager;
/**
 *  Inicia el proceso de la carga de la imagen.
 *
 *  @param rutaImagen NSString con la ruta de la imagen
 */
- (void)cargarImagenRuta:(NSString *)rutaImagen;
/**
 *  Detiene la carga de la imagen
 */
- (void)detenerCarga;
/**
 *  Borrar una carpeta
 *
 *  @param nombre NSString con nombre de la carpeta
 *
 *  @return BOOL según el resultado. YES si se borró con éxito. NO en caso de error
 */
- (BOOL)borrarImagenesCarpetaNombre:(NSString *)nombre;
/**
 *  Borra una imagen específica según su ruta
 *
 *  @param ruta ruta de la imagen
 *
 *  @return BOOL según el resultado. YES si se borró con éxito. NO en caso de error
 */
- (BOOL)borrarImagenRuta:(NSString*)ruta;
@end