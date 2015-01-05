//
//  Errores.h
//  GeoDemo
//
//  Created by Daniel on 11/5/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Errores : NSManagedObject

@property (nonatomic, retain) NSString * error;
@property (nonatomic, retain) NSString * fecha;

@end
