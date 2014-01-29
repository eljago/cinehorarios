//
//  NSObject+Utilidades.h
//  ModaSantiago
//
//  Created by Hernán Beiza on 11-03-13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface NSObject (Utilidades)

- (BOOL)conectado;
- (BOOL)esiOS7;
- (BOOL)is4InchRetina;

@end
