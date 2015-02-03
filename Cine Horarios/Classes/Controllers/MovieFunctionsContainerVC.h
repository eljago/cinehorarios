//
//  MovieFunctionsContainerVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "XHTwitterPaggingViewer2.h"

@interface MovieFunctionsContainerVC : XHTwitterPaggingViewer2

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;

@end
