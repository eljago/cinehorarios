//
//  FuncionesViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CineHorariosTableViewController.h"

@class BasicItem;

@interface FuncionesVC : CineHorariosTableViewController

@property (nonatomic, strong) NSString *theaterName;
@property (nonatomic, assign) NSUInteger theaterID;
@property (nonatomic, assign) NSUInteger cinemaID;
@end
