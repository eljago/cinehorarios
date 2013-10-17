//
//  MovieFunctionsTheatersViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CineHorariosTableViewController.h"
@interface MovieTheatersVC : CineHorariosTableViewController

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSArray *theaters;

@end
