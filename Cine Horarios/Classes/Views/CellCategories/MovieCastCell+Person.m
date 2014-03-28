//
//  MovieCastCell+MovieCast.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCastCell+Person.h"
#import "Person.h"
#import "UIImageView+CH.h"

@implementation MovieCastCell (Person)

- (void) configureForPerson:(Person *) person font:(UIFont *) font {
    
    self.nameLabel.text = person.name;
    self.nameLabel.font = font;
    [self.imageCover setImageWithStringURL:person.imageURL movieImageType:MovieImageTypeMovieImageCover];
}

@end
