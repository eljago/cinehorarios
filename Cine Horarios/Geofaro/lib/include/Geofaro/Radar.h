//
//  GPS.h
//  DemoFaro
//
//  Created by Hernan on 12/12/12.
//  Copyright (c) 2012 Nueva Spock LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@class Radar;
@protocol RadarDelegate <NSObject>
@required
- (void)radar:(Radar*)radar areaIN:(CLRegion*)areaInfo;
- (void)radar:(Radar*)radar areaOUT:(CLRegion*)areaInfo;
@end

@interface Radar : NSObject <CLLocationManagerDelegate>

@property (retain) id delegate;

+ (Radar *)sharedRADAR;
- (void)iniciar;
- (void)detenerRadar;
@end