//
//  CastVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "MWPhotoBrowser.h"
#import "CHViewTableController.h"

@class Cast;

@interface CastVC : CHViewTableController <MWPhotoBrowserDelegate>

@property (nonatomic, strong) Cast *cast;
@property (nonatomic, strong) NSMutableArray *photos;

@end
