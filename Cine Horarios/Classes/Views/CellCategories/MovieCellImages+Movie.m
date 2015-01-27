//
//  MovieCell5+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellImages+Movie.h"
#import "ArrayDataSource.h"
#import "MovieImageCell.h"
#import "MovieImageCell+MovieImage.h"

@implementation MovieCellImages (Movie)

- (void)configureForImages:(NSArray *)images {
    self.arrayDataSource = [[ArrayDataSource alloc] initWithItems:images cellIdentifier:@"Cell" configureCellBlock:^(MovieImageCell *cell, NSString *imageURL) {
        [cell configureForImageURL:imageURL];
    }];
    self.collectionView.dataSource = self.arrayDataSource;
}

+ (CGFloat) heightForRow{
    return 110.f;
}

@end
