//
//  NSObject+Utilidades.h
//  Geofaro
//
//  Created by Hernán Beiza on 5/10/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UtilidadesGeo)

//- (BOOL)capacitadoBluetoothFaro;
- (BOOL)conectado;

- (BOOL)hbLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre;

#pragma mark - iOS
- (BOOL)esiOS6;
- (BOOL)esiOS7;

#pragma mark - Modelos iPhone
- (BOOL)esiPhone5S;
- (BOOL)esiPhone5;
- (BOOL)esiPhone4S;
- (BOOL)esiPhone4;

#pragma mark - iPad o iPhone
- (BOOL)esiPad;
- (BOOL)esiPhone;
@end