//
//  TheatersViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "TheatersVC.h"
#import "CHViewTableController_Protected.h"
#import "FunctionsViewController.h"
#import "ArrayDataSource.h"
#import "GAI+CH.h"

#import "Cinema.h"
#import "Theater.h"
#import "BasicCell.h"
#import "BasicCell+Theater.h"

#import "UIColor+CH.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

@interface TheatersVC ()

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) Cinema *cinema;

@end

@implementation TheatersVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    [GAI trackPage:@"COMPLEJOS"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Cines Visitados" label:self.cinemaName];
    
    self.title = self.cinemaName;
    
    [self getDataForceDownload:NO];
}

-(void) setupDataSource {
    if (self.cinemaID == 5) {
        self.dataSource = [[ArrayDataSource alloc] initWithItems:self.cinema.theaters cellIdentifier:@"Cell2" configureCellBlock:^(BasicCell *cell, Theater *theater) {
            [cell configureForTheater:theater cinemaID:self.cinemaID];
        }];
    }
    else {
        self.dataSource = [[ArrayDataSource alloc] initWithItems:self.cinema.theaters cellIdentifier:@"Cell" configureCellBlock:^(BasicCell *cell, Theater *theater) {
            [cell configureForTheater:theater];
        }];
    }
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    BasicCell *basicCell = (BasicCell *)cell;
    basicCell.mainLabel.font = self.fontBody;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cinemaID == 5) {
        return 80.;
    }
    else {
        Theater *theater = self.cinema.theaters[indexPath.row];
        return [BasicCell heightForRowWithTheater:theater tableFont:self.fontBody];
    }
}

#pragma mark Fetch Data

- (void) getDataForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadCinema];
    }
    else {
        self.cinema = [Cinema loadCinemaWithCinemaID:self.cinemaID];
        if (self.cinema && self.cinema.theaters.count > 0) {
            self.dataSource.items = self.cinema.theaters;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self downloadCinema];
        }
    }
}

-(void) downloadCinema {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    
    [Cinema getCinemaWithBlock:^(Cinema *cinema, NSError *error) {
        if (!error) {
            if (cinema && cinema.theaters.count > 0) {
                self.cinema = cinema;
                self.dataSource.items = cinema.theaters;
                [self downloadEndedWithDownloadStatus:CHDownloadStatSuccessful];
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
    } cinemaID:self.cinemaID];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FunctionsViewController *functionsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater *theater = self.cinema.theaters[indexPath.row];
    functionsViewController.theater = theater;
}

@end
