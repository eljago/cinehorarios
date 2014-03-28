//
//  MovieImageCell+MovieImage.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieImageCell+MovieImage.h"
#import "UIImageView+CH.h"

@implementation MovieImageCell (MovieImage)

- (void) configureForImageURL:(NSString *) imageURL {
    [self.imageCover setImageWithStringURL:imageURL movieImageType:MovieImageTypeCover];
}

@end
