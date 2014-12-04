//
//  FuncionesViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CineHorariosTableViewController.h"

@class BasicItem, FunctionsPageVC;

@interface FuncionesVC : CineHorariosTableViewController

@property (nonatomic, strong) FunctionsPageVC *functionsPageVC;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *dateString;

@end
