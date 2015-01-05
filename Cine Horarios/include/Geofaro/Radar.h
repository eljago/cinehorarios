//
//  GPS.h
//  DemoFaro
//
//  Created by Hernan on 12/12/12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class Radar;
/**
 *  Delegado de la clase Radar. Se encarga de avisar a cuál región entró o salió el usuario
 */
@protocol RadarDelegate <NSObject>
@required
/**
 *  Delegado que se llama cuando se entra a una región
 *
 *  @param radar    Instancia de la clase Radar
 *  @param areaInfo CLRegion de la region
 */
- (void)radar:(Radar*)radar areaIN:(CLRegion*)areaInfo;
/**
 *  Delegado que se llama cuando se sale de una región
 *
 *  @param radar    Instancia de la clase Radar
 *  @param areaInfo CLRegion de la region
 */
- (void)radar:(Radar*)radar areaOUT:(CLRegion*)areaInfo;
@end
/**
 *  Clase que se encarga de configurar el CLLocationManager para las regiones contenidas en RegionesGeofaro.plist
 */
@interface Radar : NSObject <CLLocationManagerDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  Singletón de la clase
 *
 *  @return Instancia de Radar
 */
+ (Radar *)sharedRADAR;
/**
 *  Inicia el proceso de configuración
 */
- (void)iniciar;
/**
 *  Cancela los managers
 */
- (void)detener;
@end