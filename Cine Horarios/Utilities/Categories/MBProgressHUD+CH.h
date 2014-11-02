//
//  MBProgressHUD+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MBProgressHUD.h"
#import "RTSpinKitView.h"

@interface MBProgressHUD (CH)

+ (void) showHUDAddedTo:(UIView *)view animated:(BOOL)animated spinnerStyle:(RTSpinKitViewStyle)spinnerType;

@end
