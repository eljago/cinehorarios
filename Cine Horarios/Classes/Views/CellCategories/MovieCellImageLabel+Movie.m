//
//  MovieCell2+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellImageLabel+Movie.h"
#import "Movie.h"
#import "UIImageView+CH.h"

@implementation MovieCellImageLabel (Movie)

- (void) configureVideosCellForMovie:(Movie *)movie {
    if (movie.videos.count > 0) {
        if (movie.videos.count == 1) {
            self.labelCell.text = @"Video";
        }
        else if (movie.videos.count > 1) {
            self.labelCell.text = @"Videos";
        }
        self.imageCell.image = [UIImage imageNamed:@"IconVideos"];
    }
}

- (void) configureShowtimesCellForMovie:(Movie *)movie {
    if (movie.hasFunctions) {
        self.labelCell.text = @"Ver Horarios";
        self.imageCell.image = [UIImage imageNamed:@"IconHorarios"];
    }
}

+ (CGFloat) heightForRow {
    return 44.f;
}

@end
