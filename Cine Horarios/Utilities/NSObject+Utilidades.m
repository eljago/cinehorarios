//
//  NSObject+Utilidades.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "NSObject+Utilidades.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <CoreBluetooth/CoreBluetooth.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation NSObject (Utilidades)
/*
 - (BOOL)capacitadoBluetoothFaro
 {
 BOOL estado = YES;
 
 NSLog(@"GEOFARO: capacitadoBluetoothFaro %@",[[UIDevice currentDevice] platform]);
 
 if ([[[UIDevice currentDevice] platform] isEqualToString:@"iPhone4,1"]
 || [[[UIDevice currentDevice] platform] isEqualToString:@"iPhone5,1"]
 || [[[UIDevice currentDevice] platform] isEqualToString:@"iPhone5,2"]
 || [[[UIDevice currentDevice] platform] isEqualToString:@"iPhone6,2"])
 {
 estado = YES;
 }
 NSLog(@"GEOFARO: capacitadoBluetoothFaro %i",estado);
 
 return estado;
 }
 */

- (BOOL)conectado
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                /*
                 // if target host is not reachable
                 UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Conéctate"
                 message:@"Necesitas Internet para ocupar esta aplicación"
                 delegate:self cancelButtonTitle:@"¡Ok!" otherButtonTitles:nil, nil];
                 [alerta show];
                 */
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)hbLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre
{
    //Fecha Actual
    NSDate *sourceDate = [NSDate date];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //NSLog(@"sourceTimeZone: %@", sourceTimeZone);
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    //NSLog(@"destinationTimeZone: %@", destinationTimeZone);
    NSLocale *currentLocale = [NSLocale currentLocale];
    //NSLog(@"currentLocale: %@", [currentLocale localeIdentifier]);
    //Calendario
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:currentLocale];
    [gregorian setLocale:currentLocale];
    [gregorian setTimeZone:sourceTimeZone];
    //Formatter
    NSDateFormatter *fechaFormatter = [[NSDateFormatter alloc] init];
    [fechaFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [fechaFormatter setTimeZone:sourceTimeZone];
    [fechaFormatter setLocale:currentLocale];
    [fechaFormatter setCalendar:gregorian];
    //1 Fecha Hoy
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *fechaHoy = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    //NSLog(@"fechaHoy %@",fechaHoy);
    //2 Crear NSString con la fecha y hora de hoy
    NSString *fechaHoyString = [fechaFormatter stringFromDate:fechaHoy];
    //NSLog(@"fechaHoyString %@",fechaHoyString);
    
    //3 Ruta Directorios
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    //4 Ver si existe un log antiguo
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rutaArchivo = [NSString stringWithFormat:@"%@/%@.txt",documentDirectory,archivoNombre];
    
    NSMutableString *contenidoLog = [[NSMutableString alloc] init];
    NSString *contenidoNuevo = [NSString stringWithFormat:@"%@: %@",fechaHoyString,texto];
    
    if ([fileManager fileExistsAtPath:rutaArchivo])
    {
        //leer contenido viejo, poner la linea y guardar
        NSError* error = nil;
        contenidoLog = [NSMutableString stringWithContentsOfFile:rutaArchivo
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
    }
    
    //05 Agregar nuevo contenido
    [contenidoLog appendFormat:@"%@\n",contenidoNuevo];
    /*
     NSLog(@"contenidoNuevo %@",contenidoNuevo);
     NSLog(@"contenidoLog %@",contenidoLog);
     */
    //06 Guardar
    NSError* error = nil;
    BOOL final;
    [contenidoLog writeToFile:rutaArchivo atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        final = NO;
        //NSLog(@"no se pudo guardar");
    }else{
        final = YES;
        //NSLog(@"se guardó correctamente");
    }
    
    return final;
}

#pragma mark - iOS
- (BOOL)esiOS6
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)esiOS7
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)esiOS71
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.1"))
    {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Modelos iPhone
- (BOOL)esiPhone5S
{
    BOOL estado = NO;
    if([[[UIDevice currentDevice] platform] isEqualToString:@"iPhone6,1"]
       || [[[UIDevice currentDevice] platform] isEqualToString:@"iPhone6,2"])
    {
        estado = YES;
    }
    return estado;
}

- (BOOL)esiPhone5
{
    BOOL estado = NO;
    if([[[UIDevice currentDevice] platform] isEqualToString:@"iPhone5,1"]
       || [[[UIDevice currentDevice] platform] isEqualToString:@"iPhone5,2"])
    {
        estado = YES;
    }
    return estado;
}

- (BOOL)esiPhone4S
{
    BOOL estado = NO;
    if ([[[UIDevice currentDevice] platform] isEqualToString:@"iPhone4,1"])
    {
        estado = YES;
    }
    return estado;
}

- (BOOL)esiPhone4
{
    BOOL estado = NO;
    if ([[[UIDevice currentDevice] platform] isEqualToString:@"iPhone3,1"])
    {
        estado = YES;
    }
    return estado;
}

- (BOOL)esiPad
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //device is an iPad.
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)esiPhone
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //device is an iPhone
        return YES;
    }else{
        return NO;
    }
}

@end
