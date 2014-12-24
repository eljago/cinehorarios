//
//  CinesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinesVC.h"
#import "TheatersVC.h"
#import "BasicItemImage.h"
#import "GAI+CH.h"
#import "ArrayDataSource.h"
#import "CinemaCell.h"
#import "CinemaCell+Cinema.h"
#import "FavoritesManager.h"
#import "CHViewTableController_Protected.h"

@interface CinesVC ()
@property (nonatomic, strong) NSArray *cinemas;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@end

@implementation CinesVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"CINES"];
    
    _cinemas = [FavoritesManager sharedManager].cinemasArray;
    
    [self setupDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Low Memory warning");
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.cinemas cellIdentifier:@"Cell" configureCellBlock:^(CinemaCell *cell, BasicItemImage *cinema) {
        [cell configureForCinema:cinema];
    }];
    self.tableView.dataSource = self.dataSource;
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
