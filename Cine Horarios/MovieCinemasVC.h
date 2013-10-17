//
//  MovieFunctionsViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CineHorariosTableViewController.h"

@interface MovieCinemasVC : CineHorariosTableViewController
@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@end
