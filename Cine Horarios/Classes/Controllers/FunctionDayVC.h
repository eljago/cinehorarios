//
//  FunctionDayVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"

@interface FunctionDayVC : CHViewTableController

@property (nonatomic, strong) NSString *theaterName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger theaterID;

- (void) getDataForceDownload:(BOOL)forceDownload;

@end
