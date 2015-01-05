//
//  Beacon.h
//  Geofaro
//
//  Created by Hernán Beiza on 3/17/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Dispositivo;
/**
 *  Delegados de la clase Dispositivo
 */
@protocol DispositivoDelegate <NSObject>
/**
 *  Delegado que se llama cuando se ha encontrado un dispositivo
 *
 *  @param dispositivo  Instancia de la clase
 *  @param dispositivos NSArray con los dispositivo
 */
- (void)dispositivo:(Dispositivo*)dispositivo dispositivoEncontrados:(NSArray*)dispositivos;
/**
 *  Delegado que se llama cuando se ha encontrado un faro
 *
 *  @param dispositivo Instancia de la clase
 *  @param faroID      NSString del faro
 */
- (void)dispositivo:(Dispositivo*)dispositivo faroEncontrado:(NSString*)faroID;

@end
/**
 Clase de búsqueda de los dispositivos. 
 
 En la versión nueva, major y minor son ocupados para armar el nombre del faro y los servicios asociados a este dispositivo. 
 Luego se revisa si esos servicios están asociados a la librería según lo configurado en ServiciosGeofaro.plist. 
 Si se encuentra una similitud, se gatilla el delegado y se envía la data al servidor
 
 */
@interface Dispositivo : NSObject <CLLocationManagerDelegate,CBPeripheralDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  CLLocationManager que busca los dispositivos
 */
@property (nonatomic,strong) CLLocationManager *locManager;
/**
 @abstract CBCentralManager que busca los dispositivos
 @deprecated 1.68
 */
@property (nonatomic,strong) CBCentralManager *cbManager;
/**
 *  CBPeripheral del dispositivo
 */
@property (nonatomic,strong) CBPeripheral *elFaro;
/**
 @abstract Sin uso actualmente
 @deprecated 1.68
 */
@property int counter;
/**
 *  NSTimer que reinicia la búsqueda
 */
@property NSTimer *timer;
/**
 *  Singletón de la clase
 *
 *  @return Instancia de Dispositivo
 */
+ (Dispositivo *)sharedDispositivo;
/**
 *  Inicia la búsqueda
 */
- (void)iniciar;
/**
 *  Detiene la búsqueda de dispositivos
 */
- (void)detener;
@end