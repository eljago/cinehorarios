//
//  FunctionsCollectionCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 31-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Theater;

@protocol CollectionCellDelegate
-(void)tableCellDidSelect:(UITableViewCell *)cell;
@end

@interface FunctionsCollectionCell : UICollectionViewCell<UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *functions;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger *theaterID;
@property (nonatomic, weak) id<CollectionCellDelegate> delegate;

- (void) getDataForceDownload:(BOOL)forceDownload;
- (void) prepareCell;
@end