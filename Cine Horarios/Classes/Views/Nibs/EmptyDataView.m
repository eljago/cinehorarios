//
//  EmptyDataView.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "EmptyDataView.h"

@implementation EmptyDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor grayColor];
    
    [self.buttonGoWebPage.layer setCornerRadius:8.0f];
    [self.buttonGoWebPage.layer setMasksToBounds:YES];
    [self.buttonGoWebPage.layer setBorderWidth:1.25f];
    [self.buttonGoWebPage.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.buttonGoWebPage setTintColor:[UIColor grayColor]];
    
    [self.buttonReload.layer setCornerRadius:8.0f];
    [self.buttonReload.layer setMasksToBounds:YES];
    [self.buttonReload.layer setBorderWidth:1.25f];
    [self.buttonReload.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.buttonReload setTintColor:[UIColor grayColor]];
}


@end
