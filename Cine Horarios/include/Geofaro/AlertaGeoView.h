//
//  AlertaGeoView.h
//  Geofaro
//
//  Created by Hernán Beiza on 1/29/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertaGeoView;
/**
 *  Delegados de la clase AlertaGeoView
 */
@protocol AlertaGeoViewDelegate <NSObject>
@required
/**
 *  Delegado que se llama cuando la vista termina su animación de salida
 *
 *  @param alertViewCerrado UIView de la alerta
 */
- (void)alertViewFin:(AlertaGeoView*)alertViewCerrado;
@end
/**
 *  Clase que muestra una serie de imágenes explicando como activar el Bluetooth en iOS7
 */
@interface AlertaGeoView : UIView <UIScrollViewDelegate>
/**
 *  Delegado de la clase
 */
@property (retain) id delegate;
/**
 *  UIView de fondo de la alerta
 */
@property (nonatomic,strong) UIView *negroImageView;
/**
 *  UIView de la primera pantalla
 */
@property (nonatomic,strong) UIView *unoView;
/**
 *  UIView de la segunda pantalla
 */
@property (nonatomic,strong) UIView *dosView;
/**
 *  UIImageView de la primera pantalla
 */
@property (nonatomic,strong) UIImageView *unoImageView;
/**
 *  UIImageView de la segunda pantalla
 */
@property (nonatomic,strong) UIImageView *dosImageView;
/**
 *  UISCrollView que contiene las dos pantallas
 */
@property (nonatomic,strong) UIScrollView *alertaScrollView;
/**
 *  Botón que cierra el AlertaGeoView
 */
@property (nonatomic,strong) UIButton *graciasButton;
/**
 *  Botón que mueve el UIScrollView a la segunda pantalla
 */
@property (nonatomic,strong) UIButton *verComoButton;
/**
 *  Botón que cierra el AlertaGeoView
 */
@property (nonatomic,strong) UIButton *cancelarComoButton;
/**
 *  Función que recibe la orientación del dispositivo
 *
 *  @param orientacion orientación del dispositivo UIInterfaceOrientation
 */
- (void)configOrientacion:(UIInterfaceOrientation)orientacion;
@end