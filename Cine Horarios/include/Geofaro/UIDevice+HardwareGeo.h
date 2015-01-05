//
//  UIDevice+Hardware.h
//  DemoFaro
//
//  Created by Hernán Beiza on 17-01-13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Categoría para saber que plataforma (equipo) corresponde el actual. Es utilizadao en conjunto con NSObject-UtilidadesGeo
 */
@interface UIDevice (HardwareGeo)
/**
 *  Devuelve un NSString con la plataforma. Ejemplo "iPhone5,2" es iPhone 5
 *
 *  @return NSString con la plataforma
 */
- (NSString *) platform;
@end
