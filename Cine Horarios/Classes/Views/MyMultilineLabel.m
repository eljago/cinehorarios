//
//  MyMultilineLabel.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MyMultilineLabel.h"

@implementation MyMultilineLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    CGFloat width = CGRectGetWidth(bounds);
    if (self.preferredMaxLayoutWidth != width) {
        self.preferredMaxLayoutWidth = width;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
    }
    return self;
}

@end
