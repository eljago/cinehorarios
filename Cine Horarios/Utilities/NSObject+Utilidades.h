//
//  NSObject+Utilidades.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utilidades)
//- (BOOL)capacitadoBluetoothFaro;
- (BOOL)conectado;

- (BOOL)hbLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre;

#pragma mark - iOS
- (BOOL)esiOS6;
- (BOOL)esiOS7;
- (BOOL)esiOS71;

#pragma mark - Modelos iPhone
- (BOOL)esiPhone5S;
- (BOOL)esiPhone5;
- (BOOL)esiPhone4S;
- (BOOL)esiPhone4;

#pragma mark - iPad o iPhone
- (BOOL)esiPad;
- (BOOL)esiPhone;

@end
