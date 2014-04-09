//
//  CinemaCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinemaCell.h"
#import "UIFont+CH.h"

@implementation CinemaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.cinemaNameLabel.font = [[UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:UIContentSizeCategoryExtraExtraExtraLarge] fontWithSize:26.];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
