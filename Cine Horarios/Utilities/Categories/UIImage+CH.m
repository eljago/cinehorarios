//
//  UIImage+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-07-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIImage+CH.h"

@implementation UIImage (CH)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithCinemaID:(NSUInteger )cinemaID theaterID:(NSUInteger)theaterID {
    switch (cinemaID) {
        case 1:
            return [UIImage imageNamed:@"AnnotationCinemark"];
            break;
        case 2:
            return [UIImage imageNamed:@"AnnotationCineHoyts"];
            break;
        case 3:
            return [UIImage imageNamed:@"AnnotationCineplanet"];
            break;
        case 4:
            return [UIImage imageNamed:@"AnnotationCinemundo"];
            break;
        case 5:
            switch (theaterID) {
                case 47:
                    return [UIImage imageNamed:@"AnnotationNormandie"];
                    break;
                case 46:
                    return [UIImage imageNamed:@"AnnotationArteAlameda"];
                    break;
                case 51:
                    return [UIImage imageNamed:@"AnnotationElBiografo"];
                    break;
                case 59:
                    return [UIImage imageNamed:@"AnnotationCineAntay"];
                    break;
                case 60:
                    return [UIImage imageNamed:@"AnnotationMuseoMemoria"];
                    break;
                    
                default:
                    break;
            }
            //            view.image = [UIImage imageNamed:@"AnnotationCinesIndependientes"];
            break;
        case 6:
            return [UIImage imageNamed:@"AnnotationCinePavilion"];
            break;
        case 7:
            return [UIImage imageNamed:@"AnnotationCineStar"];
            break;
            
        default:
            break;
    }
    return nil;
}

@end
