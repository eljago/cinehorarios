//
//  CinemaCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemaCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *cinemaNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *cinemaImageView;
@end
