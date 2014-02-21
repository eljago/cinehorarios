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
#import "FaroFotoManager.h"
#import "FarosActualizacionParser.h"

@class Faro;
@protocol FaroDelegate <NSObject>
@required
- (void)faro:(Faro*)faro faroEncontrado:(NSDictionary*)faroInfo;
- (void)faro:(Faro*)faro faroEncontradoNuevo:(NSDictionary*)faroInfo;
@end

@interface Faro : NSObject <FaroEnvioDataDelegate,FaroFotoManagerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>

@property (retain) id delegate;
@property (nonatomic) float tiempo;

+ (Faro *)sharedFaro;
- (void)iniciar;

- (void)iniciarBLEconOptions:(NSDictionary*)options;
- (void)iniciarBLE;

- (void)detener;
- (void)encontreBluetoothUID:(NSString *)uid;
@end