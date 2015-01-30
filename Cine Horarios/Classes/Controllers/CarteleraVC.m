//
//  CarteleraViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CarteleraVC.h"
#import "CHViewTableController_Protected.h"
#import "ArrayDataSource.h"
#import "GAI+CH.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

#import "BasicMovie.h"
#import "MovieViewController.h"
#import "Billboard.h"
#import "BillboardCell.h"
#import "BillboardCell+BasicMovie.h"

@interface CarteleraVC ()
@property (nonatomic, strong) Billboard *billboard;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@end

@implementation CarteleraVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    [GAI trackPage:@"CARTELERA"];
        
    [self getDataForceDownload:NO];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.billboard.movies cellIdentifier:@"Cell" configureCellBlock:^(BillboardCell *cell, BasicMovie *basicMovie) {
        [cell configureForBasicMovie:basicMovie];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    BillboardCell *billboardCell = (BillboardCell *)cell;
    billboardCell.mainLabel.font = self.fontBigBold;
    billboardCell.genresLabel.font = self.fontNormal;
    billboardCell.durationLabel.font = self.fontNormal;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasicMovie *basicMovie = self.billboard.movies[indexPath.row];
    return [BillboardCell heightForRowWithBasicMovie:basicMovie headFont:self.fontNormal bodyFont:self.fontNormal];
}

#pragma mark - CarteleraVC
#pragma mark - Fetch Data
- (void) getDataForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadBillboard];
    }
    else {
        self.billboard = [Billboard loadBillboard];
        if (self.billboard && self.billboard.movies.count > 0) {
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self downloadBillboard];
        }
    }
}
-(void) downloadBillboard {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Billboard getBillboardWithBlock:^(Billboard *billboard, NSError *error) {
        if (!error) {
            if (billboard && billboard.movies.count > 0) {
                self.billboard = billboard;
                self.dataSource.items = self.billboard.movies;
            }
            else {
                [self downloadEndedWithDownloadStatus:CHDownloadStatNoDataFound];
            }
        }
        else {
            [self downloadEndedWithDownloadStatus:CHDownloadStatFailed];
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieViewController *movieViewController = segue.destinationViewController;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    BasicMovie *basicMovie = self.billboard.movies[row];
    movieViewController.movieID = basicMovie.movieID;
    movieViewController.movieName = basicMovie.name;
    movieViewController.portraitImageURL = basicMovie.portraitImageURL;
    movieViewController.coverImageURL = basicMovie.imageURL;
}

@end
