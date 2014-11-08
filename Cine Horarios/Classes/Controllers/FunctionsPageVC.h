//
//  FunctionsPageVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 07-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionsPageVC : UIPageViewController

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@property (nonatomic, strong) UIFont *showtimesFont;

@property (nonatomic, strong) NSString *theaterName;
@property (nonatomic, assign) NSUInteger theaterID;
@property (nonatomic, assign) NSUInteger cinemaID;

@end
