//
//  CastCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//


#import "CHCell.h"

@class Actor;

@interface ActorCell : CHCell

@property (nonatomic, strong) Actor *actor;
@property (nonatomic, weak) IBOutlet UIImageView *imageCover;
@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UILabel *labelRole;
+ (CGFloat)heightForCellWithActor:(Actor *)actor withNameFont:(UIFont *)fontName roleFont:(UIFont *)fontRole;
@end
