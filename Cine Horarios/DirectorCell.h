//
//  DirectorCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHCell.h"

@class Actor;

@interface DirectorCell : CHCell

@property (nonatomic, strong) Actor *actor;
@property (nonatomic, weak) IBOutlet UIImageView *imageCover;
@property (nonatomic, weak) IBOutlet UILabel *labelName;

+ (CGFloat)heightForCellWithActor:(Actor *)actor withFont:(UIFont *)font;
@end
