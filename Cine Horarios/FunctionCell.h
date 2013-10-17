//
//  FunctionCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CHCell.h"

@class Function;

@interface FunctionCell : CHCell

@property (nonatomic, strong) Function *function;
@property (nonatomic, weak) IBOutlet UIImageView *imageCover;
@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UILabel *labelTypes;
@property (nonatomic, weak) IBOutlet UILabel *labelShowtimes;

- (void)cancelImageDownload;
+ (CGFloat)heightForCellWithBasicItem:(Function *)function withBodyFont:(UIFont *)bodyFont headFont: (UIFont *)headFont;
- (void)setBodyFont:(UIFont *)bodyFont headFont:(UIFont *)headFont;
@end
