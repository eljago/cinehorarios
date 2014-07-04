//
//  FaroEnvioData.h
//  LibreriaFaro
//  Frameworks necesarios:
//  SystemConfiguration
//  Librerías Necesarias
//  https://github.com/tonymillion/Reachability
//  Created by Hernán Beiza on 17-10-12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchivoManagerFaro.h"
//#import "Reachability.h"

@class FaroEnvioData;

@protocol FaroEnvioDataDelegate <NSObject>
@required
- (void)faroEnvioDataCompletado:(FaroEnvioData*)faroEnvioData resultados:(NSMutableDictionary*)resultados;
- (void)faroEnvioDataError:(FaroEnvioData*)faroEnvioData error:(NSError*)error;
@end

@interface FaroEnvioData : NSObject <NSXMLParserDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (retain) id delegate;
+ (FaroEnvioData *)sharedFaroEnvioData;

- (void)iniciarEnviarDataParametros:(NSDictionary*)parametros;
- (void)detener;
@end
