//
//  EnvioDataGuardada.h
//  Geofaro
//
//  Created by Hernán Beiza on 4/1/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FaroEnvioDataGuardada;
/**
 *  Delegados de la clase FaroEnvioDataGuardada
 */
@protocol FaroEnvioDataGuardadaDelegate <NSObject>
/**
 *  Delegado que se llama cuando la información se ha enviado correctamente
 *
 *  @param faroEnvioDataGuardada Instancia de la clase FaroEnvioDataGuardada
 *  @param info                  NSDictionary con la información del servidor. Esta información no se toma en cuenta ya que solo se ocupa para generar estadísticas
 */
- (void)faroEnvioDataGuardada:(FaroEnvioDataGuardada*)faroEnvioDataGuardada envioCompletado:(NSDictionary*)info;
/**
 *  Delegado que se llama cuando hay algún error con el envío de la información
 *
 *  @param faroEnvioDataGuardada Instancia de la clase FaroEnvioDataGuardada
 *  @param error                 NSError con la descripción del error
 */
- (void)faroEnvioDataGuardada:(FaroEnvioDataGuardada*)faroEnvioDataGuardada envioError:(NSError*)error;
@end
/**
 *  Clase que envía la información guardada de los faros que quedaron pendientes
 */
@interface FaroEnvioDataGuardada : NSObject <NSXMLParserDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

/**
 *  Delegado de la clase
 */
@property (retain) id delegate;

/**
 *  Inicia el envío de los faros pendientes
 */
- (void)iniciar;
/**
 *  Detiene el envío de los faros pendientes
 */
- (void)detener;
@end