//
//  CarteleraViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CarteleraVC.h"
#import "BasicMovie2.h"
#import "Billboard.h"
#import "BillboardCell.h"
#import "BillboardCell+BasicMovie.h"
#import "Genre.h"
#import "NSArray+FKBMap.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ArrayDataSource.h"

@interface CarteleraVC ()
@property (nonatomic, strong) Billboard *billboard;
@property (nonatomic, strong) ArrayDataSource *dataSource;

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@end

@implementation CarteleraVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"CARTELERA" forKey:kGAIScreenName] build]];
    
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
        
    [self getBillboardForceDownload:NO];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.billboard.movies cellIdentifier:@"Cell" configureCellBlock:^(BillboardCell *cell, BasicMovie2 *basicMovie) {
        [cell configureForBasicMovie:basicMovie];
    }];
    self.tableView.dataSource = self.dataSource;
}
- (void) getBillboardForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadBillboard];
    }
    else {
        self.billboard = [Billboard loadBillboard];
        if (self.billboard) {
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
        }
        else {
            [self downloadBillboard];
        }
    }
}
-(void) downloadBillboard {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Billboard getBillboardWithBlock:^(Billboard *billboard, NSError *error) {
        if (!error) {
            self.billboard = billboard;
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getBillboardForceDownload:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark Refresh
-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getBillboardForceDownload:YES];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BillboardCell *billboardCell = (BillboardCell *)cell;
    billboardCell.mainLabel.font = self.headFont;
    billboardCell.genresLabel.font = self.bodyFont;
    billboardCell.durationLabel.font = self.bodyFont;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasicMovie2 *basicMovie = self.billboard.movies[indexPath.row];
    return [BillboardCell heightForRowWithBasicMovie:basicMovie headFont:self.headFont bodyFont:self.bodyFont];
}

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieVC *movieVC = segue.destinationViewController;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    BasicMovie2 *movie = self.billboard.movies[row];
    movieVC.movieID = movie.movieID;
    movieVC.movieName = movie.name;
    movieVC.portraitImageURL = movie.portraitImageURL;
}

@end
