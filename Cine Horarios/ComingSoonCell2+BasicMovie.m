//
//  ComingSoonCell+BasicMovie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonCell2+BasicMovie.h"
#import "UIImageView+CH.h"
#import "BasicMovie2.h"

@implementation ComingSoonCell2 (BasicMovie)

-(void) configureForBasicMovie:(BasicMovie2 *)basicMovie {
    
    self.mainLabel.text = basicMovie.name;
    if (basicMovie.debut) {
        self.debutTitleLabel.text = @"Estreno:";
        self.debutLabel.text = [basicMovie.debut description];
    }
    else{
        self.debutTitleLabel.text = @"";
        self.debutLabel.text = @"";
    }
    [self.imageCover setImageWithStringURL:basicMovie.imageURL movieImageType:MovieImageTypeCover];
    
}

+ (CGFloat) heightForRowWithBasicMovie:(BasicMovie2 *)basicMovie headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont {
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [basicMovie.name boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:headFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect durationLabelRect = [@"Estreno:" boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect genresLabelRect = [[basicMovie.debut description] boundingRectWithSize: size
                                                            options: NSStringDrawingUsesLineFragmentOrigin
                                                         attributes: [NSDictionary dictionaryWithObject:bodyFont
                                                                                                 forKey:NSFontAttributeName]
                                                            context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 15.0f + durationLabelRect.size.height + 5.0f + genresLabelRect.size.height + 10.0f;
    
    if (totalHeight < 140.f) {
        totalHeight = 140.f;
    }
    
    return totalHeight;
}

@end
