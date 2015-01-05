//
//  NSObject+Utilidades.h
//  Geofaro
//
//  Created by Hernán Beiza on 5/10/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Categoría con métodos útiles para identificar el tipo de dispositivo (iPad o iPhone), versión de iOS, si puede trabajar con BLE y si está conectado o no a internet
 */
@interface NSObject (UtilidadesGeo)
/**
 *  Detecta si el equipo puede detectar BLE
 *
 *  @return YES si está capacitado. NO en caso contrario
 */
- (BOOL)capacitadoBluetoothFaro;
/**
 *  Detecta su el equipo tiene internet
 *
 *  @return YES si está conectado. NO en caso contrario
 */
- (BOOL)conectado;
/**
 *  Función para guardar texto en un archivo de texto
 *
 *  @param texto         NSString a guardar
 *  @param archivoNombre NSString con el nombre del archivo log
 *
 *  @return YES si guardó. NO en caso contrario.
 */
- (BOOL)hbLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre;

#pragma mark - iOS
/**
 *  Detecta si este equipo usa iOS 6
 *
 *  @return YES si usa. NO en caso contrario
 */
- (BOOL)esiOS6;
/**
 *  Detecta si este equipo usa iOS 7
 *
 *  @return YES si usa. NO en caso contrario
 */
- (BOOL)esiOS7;
/**
 *  Detecta si este equipo usa iOS 8
 *
 *  @return YES si usa. NO en caso contrario
 */
- (BOOL)esiOS8;

#pragma mark - Modelos iPhone
/**
 *  Detecta si es un equipo iPhone 6+
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone6Plus;

/**
 *  Detecta si es un equipo iPhone 6
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone6;

/**
 *  Detecta si es un equipo iPhone 5S
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone5S;
/**
 *  Detecta si es un equipo iPhone 5
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone5;
/**
 *  Detecta si es un equipo iPhone 4S
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone4S;
/**
 *  Detecta si es un equipo iPhone 4
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone4;

#pragma mark - iPad o iPhone
/**
 *  Detecta si es un equipo iPad
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPad;
/**
 *  Detecta si es un equipo iPhone
 *
 *  @return YES si es. NO en caso contrario
 */
- (BOOL)esiPhone;
@end