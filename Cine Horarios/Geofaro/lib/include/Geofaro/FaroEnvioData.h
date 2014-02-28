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

@protocol FaroEnvioDataDelegate <NSObject>
@required
- (void)faroEnvioDataIniciando:(FaroEnvioData*) faroEnvioData respuesta:(NSURLResponse*)respuesta;
- (void)faroEnvioDataProgreso:(FaroEnvioData*) faroEnvioData porcentaje:(int)porcentaje;
- (void)faroEnvioDataCompletado:(FaroEnvioData*) faroEnvioData resultados:(NSMutableDictionary*)resultados;
- (void)faroEnvioDataError:(FaroEnvioData*) faroEnvioData error:(NSError*)error;

- (void)faroEnvioDataParserCompletado:(FaroEnvioData*)faroEnvioData resultados:(NSMutableDictionary*)resultados;
- (void)faroEnvioDataParserError:(FaroEnvioData*) faroEnvioData error:(NSError*)error;
@end

@interface FaroEnvioData : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>

@property (retain) id delegate;
+ (FaroEnvioData *)sharedFaroEnvioData;

// Nuevas Funciones
- (void)iniciarEnviarDataParametros:(NSDictionary*)parametros;
//- (void)enviarDataParametros:(NSDictionary*)parametros;
//- (void)guardarDataParametros:(NSDictionary*)parametros;
- (void)enviarDataGuardada;
- (void)faroEnvioIniciarRuta:(NSString*)ruta conParametros:(NSMutableDictionary*)parametros;
@end
