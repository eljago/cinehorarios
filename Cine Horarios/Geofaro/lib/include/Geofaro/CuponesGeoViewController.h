//
//  CuponesGeoViewController.h
//  Geofaro
//
//  Created by Hernán Beiza on 8/19/13.
//  Copyright (c) 2013 Geofaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuponesGeoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *cuponesTableView;

@end
