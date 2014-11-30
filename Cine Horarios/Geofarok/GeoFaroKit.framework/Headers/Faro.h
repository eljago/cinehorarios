//
//  Faro.h
//  GeoDemo
//
//  Created by Daniel on 11/6/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Faro : NSManagedObject

@property (nonatomic, retain) NSString * identificador;
@property (nonatomic, retain) NSDate * fecha;

@end
