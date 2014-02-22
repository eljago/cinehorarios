//
//  UITableViewCell+Cinema.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinemaCell.h"

@class BasicItemImage;

@interface CinemaCell (Cinema)

- (void) configureForCinema: (BasicItemImage *)cinema;

@end
