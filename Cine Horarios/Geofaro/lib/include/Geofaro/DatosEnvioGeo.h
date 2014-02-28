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
//Definir protocolo
@protocol DatosEnvioGeoDelegate <NSObject>
@required
- (void)datosEnvioGeoCompleto:(DatosEnvioGeo*)datosEnvioGeo datos:(NSMutableDictionary*)datos;
- (void)datosEnvioGeoError:(DatosEnvioGeo*)datosEnvioGeo datos:(NSMutableDictionary*)datos;
@end

@interface DatosEnvioGeo : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>

//Sintetizar el delegado
@property (retain) id delegate;
@property (nonatomic) int tag;
@property (nonatomic,strong) NSString *url;
@property (nonatomic) BOOL respuestaXML;

- (void)enviarDatosRuta:(NSString*)ruta datos:(NSMutableDictionary*)datos;

@end
