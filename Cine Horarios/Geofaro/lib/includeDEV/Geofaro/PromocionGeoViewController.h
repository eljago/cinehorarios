//
//  PromocionGeoViewController.h
//  SPKGPS
//
//  Created by Hernán Beiza on 6/11/13.
//  Copyright (c) 2013 Nueva Spock LTDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaroFotoManager.h"


#define GAName @"Promocion"

@interface PromocionGeoViewController : UIViewController <FaroFotoManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIImage *promoImage;
@property (nonatomic,strong) UIImage *errorImage;

@property (nonatomic,strong) NSDictionary *faroInfo;

@property (nonatomic,copy) NSString *screenName;

@property (nonatomic,weak) IBOutlet UIProgressView *progressView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityView;

#pragma mark - Bases
@property (weak, nonatomic) IBOutlet UIButton *abrirBasesButton;
@property (weak, nonatomic) IBOutlet UIView *basesView;
@property (weak, nonatomic) IBOutlet UIButton *cerrarBasesButton;
@property (weak, nonatomic) IBOutlet UITextView *basesTextView;

@end
