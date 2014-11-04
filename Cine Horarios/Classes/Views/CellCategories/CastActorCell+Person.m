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
    if (!person.imdbCode) {
        [self.buttonImdb setHidden:YES];
        self.buttonTrailingConstraint.constant = 50.f;
    }
    else {
        [self.buttonImdb setHidden:NO];
        self.buttonTrailingConstraint.constant = 0.f;
    }
}

+ (CGFloat) heightForRowWithPerson:(Person *)person fontName:(UIFont *)fontName fontRole:(UIFont *)fontRole{
    CGSize size = CGSizeMake(215.f, FLT_MAX);
    CGSize sizeWithButton = CGSizeMake(166.f, FLT_MAX);
    CGRect nameLabelRect;
    CGRect roleLabelRect;
    if (person.imdbCode) {
        nameLabelRect = [person.name boundingRectWithSize: sizeWithButton
                                                  options: NSStringDrawingUsesLineFragmentOrigin
                                               attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                  context: nil];
        
        roleLabelRect = [person.character boundingRectWithSize: sizeWithButton
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: @{NSFontAttributeName: fontRole}
                                                       context: nil];
    }
    else {
        nameLabelRect = [person.name boundingRectWithSize: size
                                                  options: NSStringDrawingUsesLineFragmentOrigin
                                               attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                  context: nil];
        
        roleLabelRect = [person.character boundingRectWithSize: size
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: @{NSFontAttributeName: fontRole}
                                                       context: nil];
    }
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f + roleLabelRect.size.height + 10.f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}

@end
