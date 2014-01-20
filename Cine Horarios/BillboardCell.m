//
//  BillboardCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BillboardCell.h"

@implementation BillboardCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    _durationLabel.highlightedTextColor = [UIColor whiteColor];
    _genresLabel.highlightedTextColor = [UIColor whiteColor];
}

@end