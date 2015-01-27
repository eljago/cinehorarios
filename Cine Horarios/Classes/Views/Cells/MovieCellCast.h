//
//  MovieCell3.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArrayDataSource;

@interface MovieCellCast : UITableViewCell

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ArrayDataSource *arrayDataSource;

@end
