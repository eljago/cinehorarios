//
//  FunctionsContainerVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 10-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Theater;
@interface FunctionsContainerVC : UIViewController

@property (nonatomic, assign) NSUInteger cinemaID;
@property (nonatomic, strong) Theater *theater;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end
