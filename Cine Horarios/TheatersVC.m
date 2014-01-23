//
//  TheatersViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "TheatersVC.h"
#import "Cinema.h"
#import "Theater2.h"
#import "FuncionesVC.h"
#import "UIFont+CH.h"
#import "BasicCell.h"
#import "BasicCell+Theater.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ArrayDataSource.h"

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
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"COMPLEJOS" forKey:kGAIScreenName] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Preferencias Usuario"
                                                          action:@"Cines Visitados"
                                                           label:self.cinemaName
                                                           value:nil] build]];
    
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
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.cinema.theaters cellIdentifier:@"Cell" configureCellBlock:^(BasicCell *cell, Theater2 *theater) {
        [cell configureForTheater:theater];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    BasicCell *basicCell = (BasicCell *)cell;
    basicCell.mainLabel.font = self.tableFont;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Theater2 *theater = self.cinema.theaters[indexPath.row];
    return [BasicCell heightForRowWithTheater:theater tableFont:self.tableFont];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];

    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FuncionesVC *functionesVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater2 *theater = self.cinema.theaters[indexPath.row];
    functionesVC.theaterName = theater.name;
    functionesVC.theaterID = theater.theaterID;
}



@end
