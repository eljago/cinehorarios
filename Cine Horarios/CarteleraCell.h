//
//  Cartelera.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "CHCell.h"
@class BasicMovie;
@interface CarteleraCell : CHCell

@property (nonatomic, strong) BasicMovie *basicMovie;

@property (nonatomic, weak) IBOutlet UIImageView *imageCover;
@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UILabel *labelDuration;
@property (nonatomic, weak) IBOutlet UILabel *labelGenres;

- (void)cancelImageDownload;
- (void)setBodyFont:(UIFont *)bodyFont headFont:(UIFont *)headFont;
+ (CGFloat)heightForCellWithBasicItem:(BasicMovie *)basicMovie withBodyFont:(UIFont *)bodyFont headFont: (UIFont *)headFont;
@end
