//
//  Respuesta.h
//  GeoDemo
//
//  Created by Daniel on 11/10/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Encontrado;

@interface Respuesta : NSManagedObject

@property (nonatomic, retain) NSString * texto;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * error;
@property (nonatomic, retain) Encontrado *faro;

@end
