//
//  PromocionViewController.h
//  GeoDemo
//
//  Created by Daniel on 10/29/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Anuncios.h"
#import "GFKDao.h"


@interface PromocionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titulo;

@property (weak, nonatomic) IBOutlet UIImageView *imagen;

@property Anuncios *anuncio;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actividad;


@property (weak, nonatomic) IBOutlet UIView *vistaBases;
@property (weak, nonatomic) IBOutlet UITextView *vistaTexto;

@property BOOL mostrandoBases;

@end
