//
//  CastActorCell+Actor.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastActorCell+Person.h"
#import "UIImageView+CH.h"
#import "Person.h"

@implementation CastActorCell (Person)

- (void) configureForPerson:(Person *) person {
    
    self.nameLabel.text = person.name;
    self.characterLabel.text = person.character;
    [self.imageCover setImageWithStringURL:person.imageURL movieImageType:MovieImageTypeMovieImageCover];
}

+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName fontRole:(UIFont *)fontRole{
    CGSize size = CGSizeMake(209.f, FLT_MAX);
    
    CGRect nameLabelRect = [person.name boundingRectWithSize: size
                                                    options: NSStringDrawingUsesLineFragmentOrigin
                                                  attributes: @{NSFontAttributeName: fontName}
                                                    context: nil];
    CGRect roleLabelRect = [person.character boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: @{NSFontAttributeName: fontRole}
                                                         context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f + roleLabelRect.size.height + 10.f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}

@end
