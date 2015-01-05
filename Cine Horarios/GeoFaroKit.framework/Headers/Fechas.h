//
//  Fechas.h
//  GeoDemo
//
//  Created by Daniel on 11/5/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Encontrado;

@interface Fechas : NSManagedObject

@property (nonatomic, retain) NSDate * fechaError;
@property (nonatomic, retain) NSDate * fechaOk;
@property (nonatomic, retain) Encontrado *encontrado;

@end
