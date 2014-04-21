//
//  UIImage+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-07-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CH)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithCinemaID:(NSUInteger )cinemaID theaterID:(NSUInteger)theaterID;

@end
