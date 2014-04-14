//
//  FunctionCell2+Function.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionCell2+Function.h"
#import "UIImageView+CH.h"
#import "Function.h"

@implementation FunctionCell2 (Function)

- (void) configureForFunction:(Function *) function {
    self.mainLabel.text = function.name;
    self.typesLabel.text = function.functionTypes;
    self.showtimesLabel.text = function.showtimes;
    
    [self.imageCover setImageWithStringURL:function.imageURL movieImageType:MovieImageTypeCover];
}

+ (CGFloat) heightForRowWithFunction:(Function *)function headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont showtimesFont:(UIFont *)showtimesFont{
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [function.name boundingRectWithSize: size
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: [NSDictionary dictionaryWithObject:headFont forKey:NSFontAttributeName]
                                                       context: nil];
    CGRect typesLabelRect = [function.functionTypes boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect showtimesLabelRect = [function.showtimes boundingRectWithSize: size
                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                              attributes: [NSDictionary dictionaryWithObject:showtimesFont forKey:NSFontAttributeName]
                                                                 context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 15.0f + typesLabelRect.size.height + 5.0f + showtimesLabelRect.size.height + 10.0f;
    
    if (totalHeight <= 140.f) {
        totalHeight = 140.f;
    }
    
    return totalHeight;
}

@end
