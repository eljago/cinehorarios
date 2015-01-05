//
//  FaroEnvioData.h
//  LibreriaFaro
//  Frameworks necesarios:
//  SystemConfiguration
//  Librerías Necesarias
//  https://github.com/tonymillion/Reachability
//  Created by Hernán Beiza on 17-10-12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchivoManagerFaro.h"
//#import "Reachability.h"

@class FaroEnvioData;
/**
 * Delegados de la clase FaroEnvioData
 */
@protocol FaroEnvioDataDelegate <NSObject>
@required
/**
 *  Delegado que se llama cuando está completado el envío
 *
 *  @param faroEnvioData Instancia de la clase
 *  @param resultados    NSMutableDictionary con la información del servidor. Si existe "Estado"=1, existirá "Url" de la imagen, "Titulo", "Mensaje", "Accion" y "Bases", en caso contrario solo devolverá un id. Esto se ocupa para saber si el faro tiene una promoción.
 */
- (void)faroEnvioDataCompletado:(FaroEnvioData*)faroEnvioData resultados:(NSMutableDictionary*)resultados;
/**
 *  Delegado que se llama cuando hay un error
 *
 *  @param faroEnvioData Instancia de la clase
 *  @param error         NSError con la descripción del error
 */
- (void)faroEnvioDataError:(FaroEnvioData*)faroEnvioData error:(NSError*)error;
@end
/**
Clase que envía la información del Faro al servidor. Las llaves que se envían son:
 
"fr": id del faro

"ap": ap de la librería (ConfigGeofaro.plist)
 
"ud": token del teléfono
 
"apnm": apnm de la librería (ConfigGeofaro.plist)
 
"lv": versión de la librería obtenido de la constante GeofaroVersion del archivo Geofaro-Prefix.pch
 
"hr": fecha en que se detectó el faro
 
"pl": plataforma, por defecto iOS.
 */
@interface FaroEnvioData : NSObject <NSXMLParserDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  Singletón de la clase
 *
 *  @return FaroEnvioData
 */
+ (FaroEnvioData *)sharedFaroEnvioData;
/**
 *  Enviar la información al servidor
 *
 *  @param parametros NSDictionary con las llaves que se envían al servidor
 */
- (void)iniciarEnviarDataParametros:(NSDictionary*)parametros;
/**
 *  Detiene el envío al servidor
 */
- (void)detener;
@end