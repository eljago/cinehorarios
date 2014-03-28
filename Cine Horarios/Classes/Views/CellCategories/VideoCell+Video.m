//
//  VideoCell+Video.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoCell+Video.h"
#import "Video.h"
#import "UIImageView+CH.h"
#import "BasicMovie.h"

@implementation VideoCell (Video)

-(void) configureForVideo:(Video *)video {
    self.nameLabel.text = video.movie.name;
    self.videoNameLabel.text = video.name;
    
    [self.showCoverImageView setImageWithStringURL:video.movie.imageURL movieImageType:MovieImageTypeMovieImageCover];
    [self.videoCoverImageView setImageWithStringURL:video.imageURL movieImageType:MovieImageTypeMovieVideo];
}

@end
