//
//  CastVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "MWPhotoBrowser.h"
#import "CineHorariosTableViewController.h"

@interface CastVC : CineHorariosTableViewController  <MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *directors;
@property (nonatomic, strong) NSArray *actors;
@property (nonatomic, strong) NSMutableArray *photos;

@end
