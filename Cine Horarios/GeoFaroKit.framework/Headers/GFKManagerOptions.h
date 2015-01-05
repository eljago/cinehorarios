//
//  GFKManagerOptions.h
//  GeoDemo
//
//  Created by Daniel on 10/14/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFKManagerOptions : NSObject


@property BOOL usarToken;
@property NSString *token;
@property BOOL usarRegiones;
@property NSString *idApp;
@property NSString *idCliente;
@property NSString *appName;

+(instancetype)nuevaConfiguracionParaAppID:(NSString *)App conClienteId:(NSString*)ClienteID appUsaToken:(BOOL)usaToken token:(NSString*)token appUsaRegiones:(BOOL)usaRegiones appName:(NSString*)appName;



@end
