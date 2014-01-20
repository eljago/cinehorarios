//
//  BillboardCell+BasicMovie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BillboardCell+BasicMovie.h"
#import "Genre.h"
#import "UIImageView+CH.h"
#import "NSArray+FKBMap.h"

@implementation BillboardCell (BasicMovie)

-(void) configureForBasicMovie:(BasicMovie2 *)basicMovie {
    self.mainLabel.text = basicMovie.name;
    if (basicMovie.duration) {
        self.durationLabel.text = [NSString stringWithFormat:@"%d minutos",basicMovie.duration];
    }
    else{
        self.durationLabel.text = @"";
    }
    if (basicMovie.genres) {
        NSArray *genresNames = [basicMovie.genres fkbMap:^NSString *(Genre *genre) {
            return genre.name;
        }];
        self.genresLabel.text = [genresNames componentsJoinedByString:@", "];
    }
    else{
        self.genresLabel.text = @"";
    }
    
    [self.imageCover setImageWithStringURL:basicMovie.imageURL movieImageType:MovieImageTypeCover];
    
}

@end
