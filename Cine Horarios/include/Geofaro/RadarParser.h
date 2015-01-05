//
//  CargarXML.h
//  TestGPS
//
//  Created by Hernán Beiza on 15-12-12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RadarParser;
/**
 *  Delegados de la clase RadarParser. No implementado ya que las regiones son locales y vienen en RegionesGeofaro.plist
 */
@protocol RadarParserDelegate <NSObject>
@required
/**
 *  Delegado que se llama cuando se han cargado las regiones
 *
 *  @param radarParser Instancia de la clase RadarParser
 *  @param datos       NSMutableArray datos
 */
- (void) radarParserCompleto:(RadarParser*)radarParser datos:(NSMutableArray*)datos;
/**
 *  Delegado que se llama cuando hay un error en la carga de las regiones
 *
 *  @param radarParser Instancia de la clase RadarParser
 *  @param error       NSError con la descripción del problema
 */
- (void) radarParserError:(RadarParser*)radarParser error:(NSError*)error;
@end
/**
 *  Instancia de la clase que carga las regiones desde el servidor
 */
@interface RadarParser : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  Inicia la carga del XML
 *
 *  @param rutaXML NSString con la ruta del servidor
 */
- (void)iniciarCargaRuta:(NSString*)rutaXML;
/**
 *  Inicia la carga del XML usando un NSData con la información
 *
 *  @param xmlData NSData del XML
 */
- (void)iniciarXMLData:(NSData *)xmlData;
/**
 *  Detiene la carga del XML
 */
- (void)detener;
@end