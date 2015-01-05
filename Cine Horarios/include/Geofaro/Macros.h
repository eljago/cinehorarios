//
//  Macros.h
//  Geofaro
//
//  Created by Hernán Beiza on 2/19/14 feat compadre de Fusiona
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#define DebugStatus 0  // {1: YES, otro valor NO }

#ifdef DebugStatus

#if DebugStatus == 1

#define DBLog(fmt,...) NSLog(@"\n <%@ - %@> %@",[self class], NSStringFromSelector(_cmd),[NSString stringWithFormat:(fmt), ##__VA_ARGS__]);

#else

#define DBLog(...)

#endif

#else

#define DBLog(...)

#endif

/**
 *  Macros a ocupar en la librería. DBLog
 */
@interface Macros : NSObject

@end