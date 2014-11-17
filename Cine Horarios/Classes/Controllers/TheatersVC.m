//
//  TheatersViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "TheatersVC.h"
#import "Cinema.h"
#import "Theater.h"
#import "FuncionesVC.h"
#import "UIFont+CH.h"
#import "BasicCell.h"
#import "BasicCell+Theater.h"
#import "MBProgressHUD.h"
#import "GAI+CH.h"
#import "ArrayDataSource.h"
#import "UIViewController+DoAlertView.h"
#import "MBProgressHUD+CH.h"
#import "FunctionsPageVC.h"
#import "FunctionsContainerVC.h"

@interface TheatersVC ()

@property (nonatomic, strong) UIFont *tableFont;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getTheatersForceDownload:NO];
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
    basicCell.mainLabel.font = self.tableFont;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cinemaID == 5) {
        return 80.;
    }
    else {
        Theater *theater = self.cinema.theaters[indexPath.row];
        return [BasicCell heightForRowWithTheater:theater tableFont:self.tableFont];
    }
}

#pragma mark - TheatersVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

#pragma mark Fetch Data

- (void) getTheatersForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadCinema];
    }
    else {
        self.cinema = [Cinema loadCinemaWithCinemaID:self.cinemaID];
        if (self.cinema && self.cinema.theaters.count > 0) {
            self.dataSource.items = self.cinema.theaters;
            [self.tableView reloadData];
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            [self downloadCinema];
        }
    }
}

-(void) downloadCinema {
    self.tableView.scrollEnabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    
    [Cinema getCinemaWithBlock:^(Cinema *cinema, NSError *error) {
        if (!error) {
            self.cinema = cinema;
            self.dataSource.items = cinema.theaters;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getTheatersForceDownload:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } cinemaID:self.cinemaID];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getTheatersForceDownload:YES];
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];

    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FunctionsContainerVC *functionsContainerVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater *theater = self.cinema.theaters[indexPath.row];
    functionsContainerVC.theaterID = theater.theaterID;
    functionsContainerVC.theaterName = theater.name;
}

@end
