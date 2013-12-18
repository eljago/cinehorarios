//
//  GlobalNavigationController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface GlobalNavigationController : UINavigationController <ECSlidingViewControllerDelegate>

- (IBAction)revealMenu:(id)sender;

@end
