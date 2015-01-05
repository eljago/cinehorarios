//
//  Geofaro.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/1/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Radar.h"
#import "Faro.h"
#import "DatosEnvioGeo.h"

#import "PromocionGeoViewController.h"
#import "PromocionGeoiPadViewController.h"

@class Geofaro;
/**
 Delegados de la clase Geofaro. Visibles para el desarrollador de la aplicación que montará la librería.
 */
@protocol GeofaroDelegate <NSObject>
@required
/**
 *  @abstract Delegado gatillado cuando se entra a un área de RegionesGeofaro.plist
 *  @param geofaro  Instancia de la librería
 *  @param areaInfo Objeto CLRegion con el identifier de la region
 */
- (void)geofaro:(Geofaro*)geofaro areaIN:(CLRegion*)areaInfo;
/**
 *  @abstract Delegado al salir de una área
 *
 *  @param geofaro  Instancia de la librería
 *  @param areaInfo Objeto CLRegion con el identifier de la región
 */
- (void)geofaro:(Geofaro*)geofaro areaOUT:(CLRegion*)areaInfo;
/**
 *  @abstract Delegado que se llama cada vez que se encuentra un faro.
 *
 *  @param geofaro  Instancia de la librería
 *  @param faroInfo NSDictionary con la información del faro
 */
- (void)geofaro:(Geofaro*)geofaro faroEncontrado:(NSDictionary*)faroInfo;
/**
 *  @abstract Delegado que se llama cada vez que se encuentra un faro por primera vez. Este debería llamarse una vez al día
 *
 *  @param geofaro  Instancia de la librería
 *  @param faroInfo NSDictionary con la información del faro
 */
- (void)geofaro:(Geofaro*)geofaro faroEncontradoNuevo:(NSDictionary*)faroInfo;
/**
 *  @abstract Delegado que se llama cada vez que se enceuntra un faro por primera vez y que tiene una promoción activa.
 *
 *  @param geofaro                 Instancia de la librería
 *  @param promocionViewController UIViewController con la información de la promoción.
 */
- (void)geofaro:(Geofaro*)geofaro faroEncontradoPromocionViewController:(UIViewController*)promocionViewController;
@end
/**
 Clase principal de la librería de detección de Faros. La configuración de algunos aspectos, que dependen según el cliente, se hacen en:

 RegionesGeofaro.plist: Regiones que escaneará. Más detalles en Radar.h
 
 ConfigGeofaro.plist: Configuración del AP, APNM y si ocupará regiones este cliente
 
 ServiciosGeofaro.plist: Servicios que escuchará la aplicación
 */
@interface Geofaro : NSObject <RadarDelegate,FaroDelegate,DatosEnvioGeoDelegate>
/**
 @abstract Delegado de la librería
*/
@property (retain) id delegate;
/**
 @abstract UDID o Token del teléfono
 */
@property (nonatomic,strong) NSString *ud;
/**
 @abstract Flag para activar las notificaciones locales de la librería. Por defecto YES
 */
@property (nonatomic) BOOL flagNotificaciones;
/**
 @abstract Flag para activar si se quiere ver la alerta del encendido. Por defecto YES.
 */
@property (nonatomic) BOOL flagAlertaPower;
/**
 @abstract Flag para activar si se quiere ocultar la barra de estado al abrir el UIViewController de la promoción. En el .plist de la aplicación debe venir la llave UIViewControllerBasedStatusBarAppearance en NO
 */
@property (nonatomic) BOOL flagOcultarBarraStatus;
/**
 @abstract Texto del botón cancelar de las notificaciones
 */
@property (nonatomic,strong) NSString *notificacionBotonCancel;
/**
 @abstract NSDictionary con la información recolectada del didFinishLaunchingWithOptions del AppDelegate de la aplicación.
 */
@property (nonatomic,strong) NSDictionary *launchOptions;
/**
 @abstract NSDictionary con la información recibida en los push de servicios. Geofaro only
 */
@property (nonatomic,strong) NSDictionary *servOptions;
/**
 @abstract UIViewController para iPhone que contiene la imagen y su respectiva acción
 */
@property (nonatomic,strong) PromocionGeoViewController *promocionViewController;
/**
 @abstract UIViewController para iPad que contiene la imagen y su respectiva acción
 */
@property (nonatomic,strong) PromocionGeoiPadViewController *promocioniPadViewController;
/**
 @abstract UIImage de error en caso de no poder cargar la imagen de la promoción
 */
@property (nonatomic,strong) UIImage *errorImage;
/**
 @abstract Singleton de la librería Geofaro.
 @return Geofaro
 */
+ (Geofaro *)sharedGeofaro;
/**
 @abstract Inicia la librería
 */
- (void)iniciar;
/**
 @abstract Detiene la librería
 */
- (void)detener;
/**
 @abstract Actualiza los servicios a escanear de la librería
 *
 @param servicios NSDictionary
 */
- (void)actualizarServicios:(NSDictionary*)servicios;
#pragma mark - Métodos Útiles
/**
 @abstract Devuelve un NSArray con las promociones. Cada promoción es un NSDictionary
 *
 @return NSDictionary
 */
- (NSArray *)promociones;
#pragma mark - CuponesGeoviewController
/**
 @abstract UINavigationController con un UIVewController. Posee una lista de las promociones. Sólo para pruebas
 @deprecated desde 1.68
 @return UINavigationController
 */
- (UINavigationController *)cuponesGeoNavigationViewController;
/**
 @abstract UIViewController con una lista de las promociones. Sólo para pruebas
 @deprecated desde 1.68
 @return UIViewController
 */
- (UIViewController *)cuponesGeoViewController;
@end