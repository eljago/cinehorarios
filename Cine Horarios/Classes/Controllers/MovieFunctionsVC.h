//
//  MovieFunctionsShowtimesViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CHViewTableController.h"

@interface MovieFunctionsVC : CHViewTableController

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSDate *date;

- (void) getDataForceDownload:(BOOL)forceDownload;

@end
