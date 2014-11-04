//
//  CastDirectorCell+Person.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastDirectorCell+Person.h"
#import "Person.h"
#import "UIImageView+CH.h"

@implementation CastDirectorCell (Person)

- (void) configureForPerson:(Person *) person {
    
    self.nameLabel.text = person.name;
    [self.imageCover setImageWithStringURL:person.imageURL movieImageType:MovieImageTypeMovieImageCover];
    if (!person.imdbCode) {
        [self.buttonImdb setHidden:YES];
        self.buttonTrailingConstraint.constant = -49.f;
    }
    else {
        [self.buttonImdb setHidden:NO];
        self.buttonTrailingConstraint.constant = 0.f;
    }
}

+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName{
    CGSize size = CGSizeMake(209.f, FLT_MAX);
    CGSize sizeWithButton = CGSizeMake(164.f, FLT_MAX);
    CGRect nameLabelRect;
    if (person.imdbCode) {
        nameLabelRect = [person.name boundingRectWithSize: sizeWithButton
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                         context: nil];
    }
    else {
        nameLabelRect = [person.name boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                         context: nil];
    }
    
    
    CGFloat totalHeight = 5.f + nameLabelRect.size.height +  5.f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}

@end
