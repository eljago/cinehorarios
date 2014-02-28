//
//  AlertaGeoView.h
//  Geofaro
//
//  Created by Hernán Beiza on 1/29/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertaGeoView;
@protocol AlertaGeoViewDelegate <NSObject>
@required
- (void)alertViewFin:(AlertaGeoView*)alertViewCerrado;
@end

@interface AlertaGeoView : UIView <UIScrollViewDelegate>

@property (retain) id delegate;

@property (nonatomic,strong) UIView *negroImageView;

@property (nonatomic,strong) UIView *unoView;
@property (nonatomic,strong) UIView *dosView;

@property (nonatomic,strong) UIImageView *unoImageView;
@property (nonatomic,strong) UIImageView *dosImageView;

@property (nonatomic,strong) UIScrollView *alertaScrollView;

@property (nonatomic,strong) UIButton *graciasButton;
@property (nonatomic,strong) UIButton *verComoButton;
@property (nonatomic,strong) UIButton *cancelarComoButton;

- (void)configOrientacion:(UIInterfaceOrientation)orientacion;
@end