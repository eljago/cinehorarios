//
//  ComingSoonViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonVC.h"
#import "CHViewTableController_Protected.h"
#import "MovieViewController.h"
#import "GAI+CH.h"
#import "ArrayDataSource.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

#import "BasicMovie.h"
#import "Billboard.h"
#import "ComingSoonCell2.h"
#import "ComingSoonCell2+BasicMovie.h"

@interface ComingSoonVC ()
@property (nonatomic, strong) Billboard *billboard;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@end

@implementation ComingSoonVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    [GAI trackPage:@"PROXIMAMENTE"];
        
    [self getDataForceDownload:NO];
    
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.billboard.movies cellIdentifier:@"Cell" configureCellBlock:^(ComingSoonCell2 *cell, BasicMovie *basicMovie) {
        [cell configureForBasicMovie:basicMovie];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    ComingSoonCell2 *comingSoonCell = (ComingSoonCell2 *)cell;
    comingSoonCell.mainLabel.font = self.fontBigBold;
    comingSoonCell.debutLabel.font = self.fontNormal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasicMovie *basicMovie = self.billboard.movies[indexPath.row];
    return [ComingSoonCell2 heightForRowWithBasicMovie:basicMovie headFont:self.fontBigBold bodyFont:self.fontNormal];
}

#pragma mark - ComingSoonVC
#pragma mark Fetch Data


- (void) getDataForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadComingSoon];
    }
    else {
        self.billboard = [Billboard loadComingSoon];
        if (self.billboard && self.billboard.movies.count > 0) {
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self downloadComingSoon];
        }
    }
}
-(void) downloadComingSoon {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Billboard getComingSoonWithBlock:^(Billboard *billboard, NSError *error) {
        if (!error) {
            if (billboard && billboard.movies.count > 0) {
                self.billboard = billboard;
                self.dataSource.items = self.billboard.movies;
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
