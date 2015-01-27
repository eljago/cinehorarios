//
//  MovieCell3+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellCast+Movie.h"
#import "ArrayDataSource.h"
#import "MovieCastCell.h"
#import "MovieCastCell+Person.h"

@implementation MovieCellCast (Movie)

- (void)configureForActors:(NSArray *)actors font:(UIFont *)font {
    self.arrayDataSource = [[ArrayDataSource alloc] initWithItems:actors cellIdentifier:@"Cell" configureCellBlock:^(MovieCastCell *cell, Person *person) {
        [cell configureForPerson:person font:font];
    }];
    self.collectionView.dataSource = self.arrayDataSource;
}

+ (CGFloat) heightForRow{
    return 201.f;
}

@end
