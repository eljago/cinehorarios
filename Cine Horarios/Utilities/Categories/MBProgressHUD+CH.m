//
//  MBProgressHUD+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 02-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MBProgressHUD+CH.h"

@implementation MBProgressHUD (CH)

+ (void) showHUDAddedTo:(UIView *)view animated:(BOOL)animated spinnerStyle:(RTSpinKitViewStyle)spinnerType {
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:spinnerType color:[UIColor whiteColor]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = spinner;
    
    [spinner startAnimating];
}
@end
