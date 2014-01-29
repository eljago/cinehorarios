//
//  NSObject+Utilidades.m
//  ModaSantiago
//
//  Created by Hernán Beiza on 11-03-13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import "NSObject+Utilidades.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation NSObject (Utilidades)

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


- (BOOL)esiOS7
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)is4InchRetina
{
    //NSLog(@"%f",[[UIScreen mainScreen] applicationFrame].size.width);
    //NSLog(@"%f",[[UIScreen mainScreen] applicationFrame].size.height);
    if([[UIScreen mainScreen] applicationFrame].size.height==568 || [[UIScreen mainScreen] applicationFrame].size.height==548){
        return YES;
    }
    
    /*
     if ((![UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 548) ||
     ([UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 568))
     return YES;
     */
    return NO;
}

@end
