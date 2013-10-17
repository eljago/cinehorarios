//
//  CHNavigationBar.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHNavigationBar.h"

@interface CHNavigationBar ()

@property (nonatomic, strong) CALayer *extraColorLayer;

@end

static CGFloat const kDefaultColorLayerOpacity = 0.5f;
static CGFloat const kSpaceToCoverStatusBars = 100.0f;

@implementation CHNavigationBar

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    if (self.extraColorLayer == nil) {
        self.extraColorLayer = [CALayer layer];
        self.extraColorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer addSublayer:self.extraColorLayer];
    }
    self.extraColorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.extraColorLayer != nil) {
        self.extraColorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
        [self.layer insertSublayer:self.extraColorLayer atIndex:1];
    }
}

@end
