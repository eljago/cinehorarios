//
//  CHTabBar.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHTabBar.h"

@interface CHTabBar ()

@property (nonatomic, strong) CALayer *extraColorLayer;

@end

static CGFloat const kDefaultColorLayerOpacity = 0.5f;

@implementation CHTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
        self.extraColorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self.layer insertSublayer:self.extraColorLayer atIndex:1];
    }
}

@end
