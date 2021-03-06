//
//  MovieFunctionsShowtimesViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CineHorariosTableViewController.h"

@interface MovieFunctionsVC : CineHorariosTableViewController
@property (nonatomic, strong) NSArray *theaters;
@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@end
