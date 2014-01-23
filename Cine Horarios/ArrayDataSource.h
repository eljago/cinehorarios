//
//  ArrayDataSource.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ConfigureCellBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *items;

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(ConfigureCellBlock)configureCellBlock;

@end
