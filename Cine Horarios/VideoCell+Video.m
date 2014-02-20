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
#import "UIButton+AFNetworking.h"

@implementation VideoCell (Video)

-(void) configureForVideo:(Video *)video {
    self.nameLabel.text = video.movie.name;
    self.videoNameLabel.text = video.name;
    
    NSString *strURL = [UIImageView imageURLForPath:video.movie.imageURL imageType:MovieImageTypeMovieImageCover];
    [self.showCoverButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strURL]];
    NSString *strURL2 = [UIImageView imageURLForPath:video.imageURL imageType:MovieImageTypeMovieVideo];
    [self.videoCoverButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strURL2]];
}

@end
