//
//  Accion.h
//  Geofaro
//
//  Created by Hernán Beiza on 6/25/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DatosEnvioGeo.h"
/**
 *  Clase que envía al servidor si el usuario presionó en el area sensible o botón del PromocionGeoiPadViewController o PromocionGeoViewController
 
 Según el tipo recibido en el NSDictionary de la llave Bases:
 
 1 Muestra las bases. 
 
 2 Llama por teléfono. 
 
 3 Abre un navegador
 
 */
@interface Accion : NSObject <DatosEnvioGeoDelegate>
/**
 *  Singletón de la clase
 *
 *  @return Instancia de Accion
 */
+ (Accion *)sharedAccion;
/**
 *  Envía la información al servidor
 *
 *  @param accion   NSString con el tipo de promoción. 1 Muestra las bases. 2 Llama por teléfono. 3 Abre un navegador
 *  @param idImagen NSString con el id de la imagen
 */
- (void)enviarConAccion:(NSString*)accion idImagen:(NSString*)idImagen;
@end