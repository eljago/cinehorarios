//
//  HBLog.h
//  HBLog
//
//  Created by Hernán Beiza on 6/6/13.
//  Copyright (c) 2013 Creatividad Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBPro : NSObject

+ (HBPro *)sharedHBPro;
+ (BOOL)HBLog:(NSString *)texto archivoNombre:(NSString*)archivoNombre;
@end
