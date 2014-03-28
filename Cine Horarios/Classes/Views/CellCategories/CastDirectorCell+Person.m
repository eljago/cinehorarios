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
}

+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName{
    CGSize size = CGSizeMake(211.f, 1000.f);
    
    CGRect nameLabelRect = [person.name boundingRectWithSize: size
                                                    options: NSStringDrawingUsesLineFragmentOrigin
                                                 attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                    context: nil];
    
    CGFloat totalHeight = 5.0f + nameLabelRect.size.height + 5.0f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}

@end
