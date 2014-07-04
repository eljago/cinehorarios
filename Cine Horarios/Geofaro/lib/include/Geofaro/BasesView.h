//
//  BasesView.h
//  Geofaro
//
//  Created by Hernán Beiza on 2/24/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasesView : UIView

@property (nonatomic,weak) IBOutlet UIView *negroView;
@property (nonatomic,weak) IBOutlet UIButton *cerrarButton;
@property (nonatomic,weak) IBOutlet UITextView *basesTextView;

- (void)iniciar;
- (void)abrir;
- (void)cerrar;
@end
