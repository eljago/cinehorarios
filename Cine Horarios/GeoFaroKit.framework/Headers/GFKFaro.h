//
//  GFKFaro.h
//  GeoDemo
//
//  Created by Daniel on 12/17/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GFKFaro : NSManagedObject

@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * identificador;

@end
