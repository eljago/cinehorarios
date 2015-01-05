//
//  Anuncios.h
//  GeoDemo
//
//  Created by Daniel on 10/27/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Anuncios : NSManagedObject

@property (nonatomic, retain) NSString * estado;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * mensaje;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * sonido;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * seccion;
@property (nonatomic, retain) NSString * bases;
@property (nonatomic, retain) NSData * media;
@property (nonatomic, retain) NSDate * fecha;

@end
