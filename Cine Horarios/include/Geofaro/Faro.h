//
//  Faro.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/1/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "FaroEnvioData.h"
#import "FaroEnvioDataGuardada.h"
#import "Dispositivo.h"

@class Faro;
/**
 *  Delegados de la clase Faro
 */
@protocol FaroDelegate <NSObject>
@required
/**
 *  Delegado que se llama cuando se ha encontrado un Faro viejo
 *
 *  @param faro     Instancia de la clase Faro
 *  @param faroInfo NSDictionary con la información del faro
 */
- (void)faro:(Faro*)faro faroEncontrado:(NSDictionary*)faroInfo;
/**
 *  Delegado que se llama cuando se ha encontrado un faro nuevo. Debería llamarse solo una vez al día
 *
 *  @param faro     Instancia de la clase Faro
 *  @param faroInfo NSDictionary con la información del faro
 */
- (void)faro:(Faro*)faro faroEncontradoNuevo:(NSDictionary*)faroInfo;
@end
/**
 *  Clase que se encarga de discriminar si es un faro nuevo o viejo y de enviar la información del servidor. Los servicios a buscar vienen designados en el archivo ServiciosGeofaro.plist
 */
@interface Faro : NSObject <FaroEnvioDataDelegate,FaroEnvioDataGuardadaDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,DispositivoDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  Singletón de la clase
 *
 *  @return Instancia de Faro
 */
+ (Faro *)sharedFaro;
/**
 *  Inicia la búsqueda
 */
- (void)iniciar;
/**
 *  Inicia la clase con el NSDictionary del AppDelegate que se crea en el didFinishLaunchingWithOptions
 *
 *  @param options NSDictionary obtenido del didFinishLaunchingWithOptions.
 */
- (void)iniciarBLEconOptions:(NSDictionary*)options;
/**
 *  Inicia el proceso del CBCentralManager
 */
- (void)iniciarBLE;
/**
 *  Detiene todo
 */
- (void)detener;
/**
 *  Actualiza los servicios a buscar. Máximo 4, contando los que ya trae la librería por defecto.
 *
 *  @param servs NSDictionary de servicios. SN servicios nuevos agregar. SO servicios viejos a borrar. Geofaro only!
 */
- (void)actualizarServicios:(NSDictionary*)servs;
/**
 *  Comienza el proceso de verificación según el id del faro. Si es uno nuevo o viejo.
 *
 *  @param uid id del faro
 */
- (void)encontreBluetoothUID:(NSString *)uid;
/**
 *  Devuelve los servicios actuales que están escaneando
 *
 *  @return NSArray con los servicios
 */
+ (NSArray*)serviciosActuales;
@end