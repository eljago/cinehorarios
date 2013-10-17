//
//  MovieVCViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CineHorariosTableViewController.h"

@interface MovieVC : CineHorariosTableViewController

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *portraitImageURL;

@end
