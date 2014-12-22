//
//  TheatersViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CHViewTableController.h"

@interface TheatersVC : CHViewTableController
@property (nonatomic, strong) NSString *cinemaName;
@property (nonatomic, assign) NSUInteger cinemaID;
@end
