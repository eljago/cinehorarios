//
//  FuncionesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FuncionesVC.h"
#import "FavoritesVC.h"
#import "FunctionCell2.h"
#import "UIColor+CH.h"
#import "Theater.h"
#import "Function.h"
#import "FileHandler.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "GAI+CH.h"
#import "WebVC.h"
#import "UIView+CH.h"
#import "ArrayDataSource.h"
#import "FunctionCell2+Function.h"
#import "UIViewController+DoAlertView.h"

NSString *const kHeaderString = @"No se han encontrado los horarios.";

@interface FuncionesVC ()
@property (nonatomic, strong) Theater *theater;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, strong) UIBarButtonItem *menuButtonItem;

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@property (nonatomic, assign) BOOL favorite;
@end

@implementation FuncionesVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    [GAI trackPage:@"FUNCIONES"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Complejos Visitados" label:self.theaterName];
    
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self createButtonItems];
    [self setupFavorites];
    
    [self getTheaterForceDownload:NO];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.theater.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
        [cell configureForFunction:function];
    }];
    self.tableView.dataSource = self.dataSource;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupFavorites];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    FunctionCell2 *functionCell = (FunctionCell2 *)cell;
    functionCell.mainLabel.font = self.headFont;
    functionCell.typesLabel.font = self.headFont;
    functionCell.showtimesLabel.font = self.bodyFont;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSInteger height = [UIView heightForHeaderViewWithText:self.theaterName];
    return [UIView headerViewForText:self.theaterName height:height];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIView heightForHeaderViewWithText:self.theaterName];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Function *function = self.theater.functions[indexPath.row];
    return [FunctionCell2 heightForRowWithFunction:function headFont:self.headFont bodyFont:self.bodyFont];
}

#pragma mark - FuncionesVC
#pragma mark Fetch Data

- (void) getTheaterForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadTheater];
    }
    else {
        self.theater = [Theater loadTheaterithTheaterID:self.theaterID];
        if (self.theater.functions.count > 0) {
            self.dataSource.items = self.theater.functions;
            [self.tableView reloadData];
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            [self downloadTheater];
        }
    }
}

-(void) downloadTheater {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Theater getTheaterWithBlock:^(Theater *theater, NSError *error) {
        if (!error) {
            self.theater = theater;
            if (self.theater && self.theater.functions.count > 0) {
                self.dataSource.items = self.theater.functions;
                [self.tableView reloadData];
            }
            else {
                
                [self alertWithTitle:@"Horarios no disponibles" body:[NSString stringWithFormat:@"¿Visitar página web de %@?",self.theater.name] completeBlock:^{
                    WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
                    wvc.urlString = self.theater.webURL;
                    [self.navigationController pushViewController:wvc animated:YES];
                }];
            }
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getTheaterForceDownload:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } theaterID:self.theaterID];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getTheaterForceDownload:YES];
}

#pragma mark Create View

-(void) createButtonItems {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(0, 0, 40, 40);
    [favoriteButton addTarget:self action:@selector(setFavoriteTheater:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"FavoriteHeart"];
    
    self.favoriteButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(setFavoriteTheater:)];
    self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItems = @[menuButtonItem, self.favoriteButtonItem];
}
- (void) setupFavorites{
    
    NSDictionary *dict = [FileHandler getDictionaryInProjectNamed:@"icloud"];
    NSDictionary *favorites = [dict valueForKey:@"Favorites"];
    NSString *theaterName = [favorites valueForKey:[NSString stringWithFormat:@"%d",self.theaterID]];
    if (theaterName) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
        self.favorite = YES;
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
        self.favorite = NO;
    }
}

- (IBAction) setFavoriteTheater:(id)sender{
    self.favorite = !self.favorite;
    if (self.favorite) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    }
    // Notify the previouse view to save the changes locally
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Toggle Favorite"
                                                        object:self
                                                      userInfo:@{@"TheaterName": self.theaterName,
                                                                 @"TheaterID": [NSNumber numberWithInteger:self.theaterID]}];
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieVC *movieVC = segue.destinationViewController;
    Function *function = self.theater.functions[indexPath.row];
    movieVC.movieID = function.movieID;
    movieVC.movieName = function.name;
    movieVC.portraitImageURL = function.portraitImageURL;
    movieVC.coverImageURL = function.imageURL;
}

@end
