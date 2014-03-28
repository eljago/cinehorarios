//
//  CinesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinesVC.h"
#import "TheatersVC.h"
#import "BasicItem.h"
#import "BasicItemImage.h"
#import "MTLJSONAdapter.h"
#import "GAI+CH.h"
#import "ArrayDataSource.h"
#import "CinemaCell.h"
#import "CinemaCell+Cinema.h"

@interface CinesVC ()
@property (nonatomic, strong) NSArray *cinemas;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@end

@implementation CinesVC {
    float _cellHeight;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"CINES"];
    
    [self loadCinemas];
    
    [self setupDataSource];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.cinemas cellIdentifier:@"Cell" configureCellBlock:^(CinemaCell *cell, BasicItemImage *cinema) {
        [cell configureForCinema:cinema];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - CinesVC
#pragma mark Fetch Data

- (void) loadCinemas {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cinemas" ofType:@"plist"];
    NSArray *cinemasLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableCinemas = [NSMutableArray array];
    for (NSDictionary *dict in cinemasLocal) {
        BasicItemImage *cinema = [MTLJSONAdapter modelOfClass:BasicItem.class fromJSONDictionary:dict error:NULL];
        [mutableCinemas addObject:cinema];
    }
    self.cinemas = [NSArray arrayWithArray:mutableCinemas];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TheatersVC *theatersViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    BasicItemImage *cinema = self.cinemas[indexPath.row];
    theatersViewController.cinemaID = cinema.itemID;
    theatersViewController.cinemaName = cinema.name;
}

@end
