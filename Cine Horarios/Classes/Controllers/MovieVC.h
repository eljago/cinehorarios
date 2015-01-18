//
//  MovieVCViewController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

@interface MovieVC : UITableViewController

@property (nonatomic, assign) NSUInteger movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *portraitImageURL;
@property (nonatomic, strong) NSString *coverImageURL;

@end
