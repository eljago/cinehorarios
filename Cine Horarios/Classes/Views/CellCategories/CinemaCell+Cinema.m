//
//  UITableViewCell+Cinema.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinemaCell+Cinema.h"
#import "BasicItemImage.h"

@implementation CinemaCell (Cinema)

- (void) configureForCinema: (BasicItemImage *)cinema {

    self.cinemaNameLabel.text = cinema.name;
    if (cinema.imageURL.length == 0) {
        self.cinemaImageView.image = nil;
    }
    else {
        self.cinemaImageView.image = [UIImage imageNamed:cinema.imageURL];
    }
}

@end
