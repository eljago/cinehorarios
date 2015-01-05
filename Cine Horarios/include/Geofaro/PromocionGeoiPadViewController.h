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
/**
 UIViewController con la promoción para iPad.
 Al tocar la imagen, según el tipo, puede:
 
 1 Mostrar un UITextView con un texto
 
 2 Llamar por teléfono a un número
 
 3 Abrir el navegador del equipo
 */
@interface PromocionGeoiPadViewController : UIViewController <FaroFotoManagerDelegate,UIAlertViewDelegate>
/**
 *  Imagen cargada de la promoción
 */
@property (nonatomic,strong) UIImage *promoImage;
/**
 *  Imagen a cargar en caso de error al cargar la imagen
 */
@property (nonatomic,strong) UIImage *errorImage;
/**
 *  Información de la promoción
 */
@property (nonatomic,strong) NSDictionary *faroInfo;
/**
 *  Nombre del UIViewController. Deprecada
 */
@property (nonatomic,copy) NSString *screenName;
/**
 *  Barra de progreso. Deprecada
 */
@property (nonatomic,weak) IBOutlet UIProgressView *progressView;
/**
 *  UIImageView en dónde se cargara el promoImage o errorImage.
 */
@property (nonatomic,weak) IBOutlet UIImageView *cargandoImageView;
/**
 *  UIActivityIndicatorView que mostrará que se está cargando la imagen
 */
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityView;

#pragma mark - Bases
/**
 *  UIButton transparente que ejecuta la acción según el tipo
 */
@property (nonatomic,weak) IBOutlet UIButton *abrirBasesButton;
/**
 *  UIView en dónde se muestra el texto
 */
@property (nonatomic,weak) IBOutlet BasesView *basesView;

#pragma mark - Botones
/**
 *  UIButton para cerrar el UIViewController presentado modalmente
 */
@property (nonatomic,weak) IBOutlet UIButton *salirButton;
/**
 *  UIButton para guardar esta promoción
 */
@property (nonatomic,weak) IBOutlet UIButton *guardarButton;
/**
 *  UIButton para reintentar la carga de la imagen en caso de problemas con el internet
 */
@property (nonatomic,weak) IBOutlet UIButton *reintentarButton;

@end