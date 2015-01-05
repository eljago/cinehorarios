//
//  HBLog.h
//  HBLog
//
//  Created by Hernán Beiza on 6/6/13.
//  Copyright (c) 2013 Creatividad Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Clase para guardar mis funciones
 */
@interface HBPro : NSObject
/**
 *  Singleton de la clase
 *
 *  @return instancia de HBPro
 */
+ (HBPro *)sharedHBPro;
/**
 *  Función que crear un archivo de texto en NSDocumentDirectory y guarda una línea de texto en él. Si el archivo ya está creado, adjunta la línea al final
 *
 *  @param texto         NSString a guardar
 *  @param archivoNombre NSString con el nombre del archivo de texto
 *
 *  @return BOOL YES si guardó. NO si hay algún error.
 */
+ (BOOL)HBLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre;
@end
