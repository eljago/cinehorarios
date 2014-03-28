//
//  UITableViewCell+Cinema.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinemaCell+Cinema.h"
#import "BasicItemImage.h"

@implementation UITableViewCell (Cinema)

- (void) configureForCinema: (BasicItemImage *)cinema {

    ((UILabel *)[self viewWithTag:101]).text = cinema.name;
    if ([cinema.imageURL isEqualToString:@""]) {
        ((UIImageView *)[self viewWithTag:100]).image = nil;
    }
    else {
        ((UIImageView *)[self viewWithTag:100]).image = [UIImage imageNamed:cinema.imageURL];
    }
}

@end
