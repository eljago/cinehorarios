//
//  MovieCell0+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellTop+Movie.h"
#import "Movie.h"
#import "UIImageView+CH.h"

@implementation MovieCellTop (Movie)

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0.f, self.bounds.size.width, 0.f, 0.f);
    self.clipsToBounds = NO;
}

- (void)configureForMovie:(Movie *)movie coverImageURL:(NSString *)coverImageURL portraitImageURL:(NSString *)portraitImageURL {
    if (coverImageURL) {
        [self.imageCover setImageWithStringURL:coverImageURL movieImageType:MovieImageTypeCover];
    }
    else if (movie.imageURL) {
        [self.imageCover setImageWithStringURL:movie.imageURL movieImageType:MovieImageTypeCover];
    }
    
    if (portraitImageURL) {
        [self.imagePortrait setImageWithStringURL:portraitImageURL movieImageType:MovieImageTypePortrait];
    }
    if (movie.name) {
        self.labelMovieName.text = movie.name;
    }
}

+ (CGFloat) heightForRow {
    return 135.f;
}

@end
