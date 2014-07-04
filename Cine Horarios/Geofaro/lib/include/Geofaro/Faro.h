//
//  Faro.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/1/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "FaroEnvioData.h"
#import "FaroEnvioDataGuardada.h"
#import "Beacon.h"

@class Faro;
@protocol FaroDelegate <NSObject>
@required
- (void)faro:(Faro*)faro faroEncontrado:(NSDictionary*)faroInfo;
- (void)faro:(Faro*)faro faroEncontradoNuevo:(NSDictionary*)faroInfo;
@end

@interface Faro : NSObject <FaroEnvioDataDelegate,FaroEnvioDataGuardadaDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,BeaconDelegate>

@property (retain) id delegate;

+ (Faro *)sharedFaro;
- (void)iniciar;

- (void)iniciarBLEconOptions:(NSDictionary*)options;
- (void)iniciarBLE;

- (void)detener;

- (void)actualizarServicios:(NSDictionary*)servs;
- (void)encontreBluetoothUID:(NSString *)uid;

+ (NSArray*)serviciosActuales;
@end