//
//  PromocionGeoiPadViewController.h
//  Geofaro
//
//  Created by Hernán Beiza on 1/20/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaroFotoManager.h"
#define GAName @"Promocion"

@interface PromocionGeoiPadViewController : UIViewController <FaroFotoManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIImage *promoImage;
@property (nonatomic,strong) UIImage *errorImage;

@property (nonatomic,strong) NSDictionary *faroInfo;

@property (nonatomic,copy) NSString *screenName;

@property (nonatomic,weak) IBOutlet UIProgressView *progressView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityView;
@end
