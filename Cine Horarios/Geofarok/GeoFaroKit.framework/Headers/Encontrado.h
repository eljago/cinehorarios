//
//  Encontrado.h
//  GeoDemo
//
//  Created by Daniel on 11/10/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fechas, Respuesta;

@interface Encontrado : NSManagedObject

@property (nonatomic, retain) NSNumber * enviado;
@property (nonatomic, retain) NSString * error;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * identificador;
@property (nonatomic, retain) NSString * respuesta;
@property (nonatomic, retain) NSNumber * visto;
@property (nonatomic, retain) NSSet *fechas;
@property (nonatomic, retain) NSSet *respuetas;
@end

@interface Encontrado (CoreDataGeneratedAccessors)

- (void)addFechasObject:(Fechas *)value;
- (void)removeFechasObject:(Fechas *)value;
- (void)addFechas:(NSSet *)values;
- (void)removeFechas:(NSSet *)values;

- (void)addRespuetasObject:(Respuesta *)value;
- (void)removeRespuetasObject:(Respuesta *)value;
- (void)addRespuetas:(NSSet *)values;
- (void)removeRespuetas:(NSSet *)values;

@end
