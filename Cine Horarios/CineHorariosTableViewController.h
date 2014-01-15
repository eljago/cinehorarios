//
//  CineHorariosTableViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoAlertView.h"

@interface CineHorariosTableViewController : UITableViewController
@property (nonatomic, strong) DoAlertView *alert;

-(void) alertRetryWithCompleteBlock:(void (^)())completeBlock;
@end
