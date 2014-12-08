//
//  BasicCell+Theater.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicCell+Theater.h"
#import "Theater.h"
#import "UIImage+CH.h"

@implementation BasicCell (Theater)

-(void) configureForTheater:(Theater *)theater{
    self.mainLabel.text = theater.name;
}
-(void) configureForTheater:(Theater *)theater cinemaID: (NSUInteger)cinemaID{
    self.mainLabel.text = theater.name;
    self.theaterImageView.image = [UIImage cinemaImageWithCinemaID:cinemaID theaterID:theater.theaterID];
}

+ (CGFloat) heightForRowWithTheater:(Theater *)theater tableFont:(UIFont *)font{
    CGSize size = CGSizeMake(267., CGFLOAT_MAX);
    
    CGRect nameLabelRect = [theater.name boundingRectWithSize: size
                                                      options: NSStringDrawingUsesLineFragmentOrigin
                                                   attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                      context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
    
    return totalHeight;
}

@end
