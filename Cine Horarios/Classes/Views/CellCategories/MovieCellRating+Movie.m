//
//  MovieCellRating+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 25-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellRating+Movie.h"

@implementation MovieCellRating (Movie)

- (void)configureForRating:(NSString *)score image:(UIImage *)image webpageName:(NSString *)webpageName {
    self.labelScore.text = score;
    self.imageViewLogo.image = image;
    self.labelWebPage.text = webpageName;
}

+ (CGFloat) heightForRow{
    return 50.f;
}

@end
