//
//  BasicCell+Theater.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicCell+Theater.h"
#import "Theater2.h"

@implementation BasicCell (Theater)

-(void) configureForTheater:(Theater2 *)theater {
    self.mainLabel.text = theater.name;
}

+ (CGFloat) heightForRowWithTheater:(Theater2 *)theater tableFont:(UIFont *)font{
    CGSize size = CGSizeMake(270.0, 1000.0);
    
    CGRect nameLabelRect = [theater.name boundingRectWithSize: size
                                                      options: NSStringDrawingUsesLineFragmentOrigin
                                                   attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                      context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
    
    return totalHeight;
}

@end
