//
//  Beacon.h
//  Geofaro
//
//  Created by Hernán Beiza on 3/17/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Beacon;

@protocol BeaconDelegate <NSObject>
- (void)beacon:(Beacon*)beacon beaconEncontrados:(NSArray*)beacons;
@end

@interface Beacon : NSObject <CLLocationManagerDelegate,CBPeripheralDelegate>
@property (retain) id delegate;

@property CLLocationManager *locManager;
@property CBCentralManager *cbManager;
@property (nonatomic,strong) CBPeripheral *elFaro;
@property int counter;

@property NSTimer *timer;

+ (Beacon *)sharedBeacon;
- (void)iniciar;
@end