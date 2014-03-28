//
//  VideoCell+Video.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoCell.h"

@class Video;

@interface VideoCell (Video)

-(void) configureForVideo:(Video *)video;

@end
