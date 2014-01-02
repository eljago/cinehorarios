//
//  MapsCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-12-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MapsCell.h"

@implementation MapsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton *disclosureButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    disclosureButton.imageView.image = [UIImage imageNamed:@"IconHorarios"];
    disclosureButton.tintColor = [UIColor blackColor];
    self.accessoryView = disclosureButton;
}

@end
