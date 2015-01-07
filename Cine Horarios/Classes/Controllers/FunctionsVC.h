//
//  FunctionsVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "XHTwitterPaggingViewer.h"

@class Theater;

@interface FunctionsVC : XHTwitterPaggingViewer

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (nonatomic, strong) Theater *theater;

@end
