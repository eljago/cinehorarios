//
//  AppDelegate+Geofaro.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 27-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate+Geofaro.h"

@implementation AppDelegate (Geofaro)

- (void)setGeofaroLaunchOptions:(NSString *)imdbAppUrlString { objc_setAssociatedObject(self, @selector(imdbAppUrlString), imdbAppUrlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSString *)imdbAppUrlString { return objc_getAssociatedObject(self, @selector(imdbAppUrlString)); }

- (void)setWebToOpenUrlString:(NSString *)webToOpenUrlString { objc_setAssociatedObject(self, @selector(webToOpenUrlString), webToOpenUrlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSString *)webToOpenUrlString { return objc_getAssociatedObject(self, @selector(webToOpenUrlString)); }

@end
