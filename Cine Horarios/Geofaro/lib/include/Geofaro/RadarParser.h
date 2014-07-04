//
//  CargarXML.h
//  TestGPS
//
//  Created by Hernán Beiza on 15-12-12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RadarParser;

@protocol RadarParserDelegate <NSObject>
@required
- (void) radarParserCompleto:(RadarParser*)radarParser datos:(NSMutableArray*)datos;
- (void) radarParserError:(RadarParser*)radarParser error:(NSError*)error;
@end

@interface RadarParser : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (retain) id delegate;

- (void)iniciarCargaRuta:(NSString*)rutaXML;
- (void)iniciarXMLData:(NSData *)xmlData;

@end