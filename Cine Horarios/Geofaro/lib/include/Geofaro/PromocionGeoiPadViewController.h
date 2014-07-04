//
//  PromocionGeoiPadViewController.h
//  Geofaro
//
//  Created by Hernán Beiza on 1/20/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaroFotoManager.h"

#import "BasesView.h"

#define GAName @"Promocion"

@interface PromocionGeoiPadViewController : UIViewController <FaroFotoManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIImage *promoImage;
@property (nonatomic,strong) UIImage *errorImage;

@property (nonatomic,strong) NSDictionary *faroInfo;

@property (nonatomic,copy) NSString *screenName;

@property (nonatomic,weak) IBOutlet UIProgressView *progressView;
@property (nonatomic,weak) IBOutlet UIImageView *cargandoImageView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityView;

#pragma mark - Bases
@property (nonatomic,weak) IBOutlet UIButton *abrirBasesButton;
@property (nonatomic,weak) IBOutlet BasesView *basesView;

#pragma mark - Botones
@property (nonatomic,weak) IBOutlet UIButton *salirButton;
@property (nonatomic,weak) IBOutlet UIButton *guardarButton;
@property (nonatomic,weak) IBOutlet UIButton *reintentarButton;

@end