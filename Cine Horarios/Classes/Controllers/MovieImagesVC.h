//
//  MovieImagesVCViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//
#import "MWPhotoBrowser.h"

@interface MovieImagesVC : UICollectionViewController <MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *imagesURL;
@property (nonatomic, strong) NSMutableArray *photos;
@end
