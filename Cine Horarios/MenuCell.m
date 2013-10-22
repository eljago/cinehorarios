//
//  MenuCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MenuCell.h"
#import "UIColor+CH.h"

@implementation MenuCell

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
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.10f];
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
