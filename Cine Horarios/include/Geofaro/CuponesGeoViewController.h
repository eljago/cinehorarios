//
//  CuponesGeoViewController.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/19/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * UIViewController que muestra una lista de las promociones. Al seleccionar una celda, abre un PromocionGeoViewController para iPhone. Para iPad no existe un UIViewController con la lista de promociones. En el futuro este UIViewController será deprecado.
 */
@interface CuponesGeoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
/**
 *  UITableView que muestra una lista de promociones
 */
@property (nonatomic,weak) IBOutlet UITableView *cuponesTableView;
/**
 *  UIView dentro del UITableView.
 */
@property (nonatomic,weak) IBOutlet UIView *cabeceraView;
/**
 *  UIView dentro del UITableView
 */
@property (nonatomic,weak) IBOutlet UIView *pieView;

@end