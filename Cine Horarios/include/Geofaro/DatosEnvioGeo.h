//
//  DatosEnvio.h
//  Posstal
//
//  Created by Informática Spock on 26-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@class DatosEnvioGeo;
/**
 *  Delegados de la clase DatosEnvioGeo
 */@protocol DatosEnvioGeoDelegate <NSObject>
@required
/**
 *  Delegado que se gatilla cuando el envío se completa correctamente
 *
 *  @param datosEnvioGeo instancia de DatosEnvioGeo
 *  @param datos         NSMutableDictionary con la respuesta del servidor
 */
- (void)datosEnvioGeoCompleto:(DatosEnvioGeo*)datosEnvioGeo datos:(NSMutableDictionary*)datos;
/**
 *  Delegado que se gatilla cuando el envío ha resultado erróneo
 *
 *  @param datosEnvioGeo instancia de DatosEnvioGeo
 *  @param datos         NSMutableDictionary con la respuesta del servidor y el error
 */
- (void)datosEnvioGeoError:(DatosEnvioGeo*)datosEnvioGeo datos:(NSMutableDictionary*)datos;
@end
/**
 *  Clase que envía información en formato NSMutableDictionary a una ruta determinada
 */
@interface DatosEnvioGeo : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>

/**
 *  Delegado
 */
@property (retain) id delegate;
/**
 *  Tag para identificar entre varias instancias
 */
@property (nonatomic) int tag;
/**
 *  Ruta a la que se está enviando la información
 */
@property (nonatomic, strong) NSString *url;
/**
 *  Si la respuesta del servidor es en XML debe ser YES. Por defecto su valor es YES
 */
@property (nonatomic) BOOL respuestaXML;
/**
 *  Inicia el envío de datos y NSMutableDiciontary a la ruta especifica
 *
 *  @param ruta  NSString con la ruta del servidor
 *  @param datos NSMutableDictionary con los parámetros del servidor
 */
- (void)enviarDatosRuta:(NSString*)ruta datos:(NSMutableDictionary*)datos;

@end
