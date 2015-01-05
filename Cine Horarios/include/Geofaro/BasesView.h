//
//  BasesView.h
//  Geofaro
//
//  Created by Hernán Beiza on 2/24/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Clase que muestra las bases en el UIViewController PromocionGeoViewController o PromocionGeoiPadViewController. 
 
 Consta de un UIView con el texto en un UITextView. Solo se mostrará si el Tipo recibido es 1.
 */
@interface BasesView : UIView
/**
 *  UIView semitransparante
 */
@property (nonatomic,weak) IBOutlet UIView *negroView;
/**
 *  UIButton para cerrar la vista
 */
@property (nonatomic,weak) IBOutlet UIButton *cerrarButton;
/**
 *  UITextView que contiene el texto
 */
@property (nonatomic,weak) IBOutlet UITextView *basesTextView;
/**
 *  Inicia la vista.
 */

- (void)iniciar;
/**
 *  Inicia la animación de entrada
 */
- (void)abrir;
/**
 *  Inicia la animación de salida y pone Hidden YES
 */
- (void)cerrar;
@end
