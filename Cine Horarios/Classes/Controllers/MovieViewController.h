//
//  MovieViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"

@interface MovieViewController : CHViewTableController

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *portraitImageURL;
@property (nonatomic, strong) NSString *coverImageURL;

@end
