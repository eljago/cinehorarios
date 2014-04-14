//
//  EnvioDataGuardada.h
//  Geofaro
//
//  Created by Hernán Beiza on 4/1/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FaroEnvioDataGuardada;
@protocol FaroEnvioDataGuardadaDelegate <NSObject>
- (void)faroEnvioDataGuardada:(FaroEnvioDataGuardada*)faroEnvioDataGuardada envioCompletado:(NSDictionary*)info;
- (void)faroEnvioDataGuardada:(FaroEnvioDataGuardada*)faroEnvioDataGuardada envioError:(NSError*)error;
@end
@interface FaroEnvioDataGuardada : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>

@property (retain) id delegate;

- (void)iniciar;
- (void)detener;
@end
