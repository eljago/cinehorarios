//
//  GFKCommunications.h
//  GeoDemo
//
//  Created by Daniel on 11/7/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GFKDao.h"
#import "Encontrado.h"
#import "GFKManagerOptions.h"
#import "Anuncios.h"
#import "PromocionViewController.h"
#import "GFKInterface.h"
#import "Respuesta.h"

@interface GFKCommunications : NSObject<NSURLSessionDelegate,NSXMLParserDelegate>

@property Encontrado *este;
@property GFKDao *dao;

@property GFKManagerOptions *opcionesConfiguracion;
- (void)enviarFaro:(Encontrado*)encontrado;


@property NSMutableDictionary *dk;
@property NSMutableString *str;

@property (nonatomic, assign) dispatch_once_t onceToken;
@property BOOL flagP;

@end
