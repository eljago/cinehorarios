//
//  FavoritesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FavoritesVC.h"
#import "Theater.h"
#import "BasicCell.h"
#import "BasicCell+Theater.h"
#import "GAI+CH.h"
#import "FunctionsVC.h"
#import "FavoritesManager.h"
#import "ImageViewTableHeader.h"
#import "UIImage+CH.h"
#import "CHViewTableController_Protected.h"
#import "BasicItemImage.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

static const NSString *kTheatersArray = @"TheatersArray";
static const NSString *kCinema = @"CinemasArray";

@interface FavoritesVC ()
@property (nonatomic, strong) UIBarButtonItem *buttonEdit;
@property (nonatomic, strong) NSMutableArray *favoriteTheatersSections;
@end

@implementation FavoritesVC {
    BOOL viewAppeared;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"FAVORITOS"];
    
    self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
    self.navigationItem.leftBarButtonItem = self.buttonEdit;
    
    [self getFavoritesForceDownload:NO];
}

// Reload data after coming back from Theater view in case there was an edit
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (viewAppeared){
        [self gotDataSoReload];
    }
    viewAppeared = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.favoriteTheatersSections.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoriteTheatersSections[section][kTheatersArray] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *identifier = @"Cell";
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Theater *theater = self.favoriteTheatersSections[indexPath.section][kTheatersArray][indexPath.row];
    cell.mainLabel.text = theater.name;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Theater *theater = self.favoriteTheatersSections[indexPath.section][kTheatersArray][indexPath.row];
        [self.favoriteTheatersSections[indexPath.section][kTheatersArray] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
        [favoritesManager removeTheaterWithTheaterID:theater.theaterID];
        
        if ([self.favoriteTheatersSections[indexPath.section][kTheatersArray] count] == 0) {
            [self.favoriteTheatersSections removeObjectAtIndex:indexPath.section];
        }
        
        if (favoritesManager.favoriteTheaters.count == 0) {
            tableView.editing = NO;
            self.buttonEdit.enabled = NO;
            [self downloadEndedWithDownloadStatus:CHDownloadStatNoDataFound];
        }
        else {
            self.buttonEdit.enabled = YES;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BasicItemImage *cinema = self.favoriteTheatersSections[section][kCinema];
    Theater *theater = [self.favoriteTheatersSections[section][kTheatersArray] firstObject];
    ImageViewTableHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImageViewTableHeader" owner:self options:nil] lastObject];
    headerView.imageView.image = [UIImage imageWithCinemaID:cinema.itemID theaterID:theater.theaterID];
    headerView.textLabel.text = cinema.name;
    return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    BasicCell *basicCell = (BasicCell *)cell;
    basicCell.mainLabel.font = self.fontNormal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BasicCell heightForRowWithTheater:self.favoriteTheatersSections[indexPath.section][kTheatersArray][indexPath.row] tableFont:self.fontNormal];
}

#pragma mark Fetch Data

- (void) getFavoritesForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadFavorites];
    }
    else {
        if ([FavoritesManager getShouldDownloadFavorites]) {
            [self downloadFavorites];
        }
        else {
            [self gotDataSoReload];
        }
    }
}

- (void) downloadFavorites {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    [favoritesManager downloadFavoriteTheatersWithBlock:^(NSError *error) {
        if (!error) {
            [self gotDataSoReload];
        }
        else {
            NSLog(@"%@",error.localizedDescription);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void) gotDataSoReload {
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    if (favoritesManager.favoriteTheaters.count == 0) {
        self.buttonEdit.enabled = NO;
        [self downloadEndedWithDownloadStatus:CHDownloadStatNoDataFound];
    }
    else {
        self.buttonEdit.enabled = YES;
        [self downloadEndedWithDownloadStatus:CHDownloadStatSuccessful];
    }
    [self createFavoriteTheatersSectionsArray];
    [self.tableView reloadData];
}

- (void) createFavoriteTheatersSectionsArray {
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    NSMutableArray *favSections = [NSMutableArray new];
    
    for (BasicItemImage *cinema in favoritesManager.cinemasArray) {
        NSMutableArray *theatersFiltered = [[favoritesManager getTheatersWithCinemaID:cinema.itemID] mutableCopy];
        if (theatersFiltered.count > 0) {
            [favSections addObject:@{
                                     kCinema: cinema,
                                     kTheatersArray: theatersFiltered
                                     }];
        }
    }
    self.favoriteTheatersSections = favSections;
}

#pragma mark IBActions

- (IBAction) enterEditingMode:(UIBarButtonItem *) sender{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
    }
    else{
        [self.tableView setEditing:YES animated:YES];
        self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditingMode:)];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FunctionsVC *functionsVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater *theater = self.favoriteTheatersSections[indexPath.section][kTheatersArray][indexPath.row];
    functionsVC.theater = theater;
}



#pragma mark - Empty Data Set DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"No tiene complejos Favoritos";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Para agregar un complejo a favoritos, toque el corazón en la ventana de horarios.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
