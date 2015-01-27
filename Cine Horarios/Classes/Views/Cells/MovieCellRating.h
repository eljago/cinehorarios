//
//  MovieCellRating.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 25-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellRating : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelScore;
@property (nonatomic, weak) IBOutlet UILabel *labelWebPage;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewLogo;

@end
