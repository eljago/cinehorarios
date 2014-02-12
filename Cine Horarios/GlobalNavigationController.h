//
//  GlobalNavigationController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface GlobalNavigationController : UINavigationController <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;

- (IBAction)revealMenu:(id)sender;

@end
