//
//  FarosActualizacionParser.h
//  Geofaro
//
//  Created by Hernán Beiza on 6/18/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FarosActualizacionParser;

@protocol FarosActualizacionDelegate <NSObject>
@required
- (void)farosActualizarParserCompleto:(FarosActualizacionParser*)radarParser faros:(NSMutableArray*)faros;
- (void)farosActualizarParserError:(FarosActualizacionParser*)radarParser error:(NSError*)error;
@end

@interface FarosActualizacionParser : NSObject <NSXMLParserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (retain) id delegate;

+ (FarosActualizacionParser *)sharedFarosActualizacionParser;

- (void)iniciarCargaRuta:(NSString*)rutaXML;
- (void)iniciarXMLData:(NSData *)xmlData;

@end