//
//  MovieFunctionsShowtimesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieFunctionsVC.h"
#import "CHViewTableController_Protected.h"

#import "Function.h"
#import "Theater.h"

#import "GAI+CH.h"
#import "UIView+CH.h"
#import "FavoritesManager.h"

#import "BasicItemImage.h"
#import "UIImage+CH.h"

#import "ImageViewTableHeader.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

@interface MovieFunctionsVC ()
@property (nonatomic, strong) NSArray *cinemasTheatersFunctions;
@property (nonatomic, strong) NSArray *theaterFuctions;
@property (nonatomic, weak) IBOutlet UILabel *labelNotice;
@end

@implementation MovieFunctionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.movieName;
    
    [GAI trackPage:@"PELICULA FUNCIONES"];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, self.view.bounds.size.width, 0, 0);
    
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    if (favoritesManager.favoriteTheaters.count > 0) {
        [self downloadMovieFunctions];
    }
    else {
        self.labelNotice.text = @"No tiene cines favoritos";
        self.labelNotice.hidden = NO;
        self.tableView.hidden = YES;
    }
}
-(void) downloadMovieFunctions{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    
    [Function getMovieTheatersFavoritesWithBlock:^(NSArray *theaterFunctions, NSError *error) {
        if (!error) {
            self.theaterFuctions = theaterFunctions;
            if (theaterFunctions.count > 0) {
                
                self.tableView.separatorInset = UIEdgeInsetsMake(0, 15., 0, 0);
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cinemaID" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                self.theaterFuctions = [self.theaterFuctions sortedArrayUsingDescriptors:sortDescriptors];
                [self loadCinemasTheatersFunctionsArray];
                
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            else {
                self.labelNotice.text = [NSString stringWithFormat:@"%@ no tiene funciones en sus cines favoritos para este día", self.movieName];
                self.labelNotice.hidden = NO;
                self.tableView.hidden = YES;
            }
        }
        else {
            self.tableView.hidden = YES;
            self.labelNotice.text = @"Ha ocurrido un error";
            self.labelNotice.hidden = NO;
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
    } movieID:self.movieID theaters:[FavoritesManager sharedManager].favoriteTheaters];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self downloadMovieFunctions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Theater *theater = [self.theaterFuctions objectAtIndex:indexPath.section];
    if (!theater) {
        return 0.f;
    }
    Function *function = [theater.functions objectAtIndex:indexPath.row];
    if (!function) {
        return 0.f;
    }
    CGSize size = CGSizeMake(280.f, 1000.f);
    
    CGRect typesLabelRect = [function.functionTypes boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:self.fontNormal forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect showtimesLabelRect = [function.showtimes boundingRectWithSize: size
                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                              attributes: [NSDictionary dictionaryWithObject:self.fontNormal forKey:NSFontAttributeName]
                                                                 context: nil];
    CGFloat typesHeight = typesLabelRect.size.height;
    if (!function.functionTypes || [function.functionTypes isEqualToString:@""]) {
        typesHeight = 0.;
    }
    CGFloat totalHeight = 10.0f + typesHeight + 10.0f + showtimesLabelRect.size.height + 10.0f;
    
    return totalHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cinemasTheatersFunctions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Theater *theater = self.cinemasTheatersFunctions[section];
    return theater.functions.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    UILabel *functionTypes = (UILabel *)[cell viewWithTag:1];
    UILabel *functionShowtimes = (UILabel *)[cell viewWithTag:2];
    functionTypes.font = self.fontNormal;
    functionShowtimes.font = self.fontNormal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Theater *theater = self.theaterFuctions[indexPath.section];
    Function *function = theater.functions[indexPath.row];
    
    UILabel *functionTypes = (UILabel *)[cell viewWithTag:1];
    UILabel *functionShowtimes = (UILabel *)[cell viewWithTag:2];
    functionTypes.text = [function.functionTypes stringByAppendingString:@":"];
    functionShowtimes.text = function.showtimes;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Theater *theater = self.theaterFuctions[section];
    BasicItemImage *cinema = [FavoritesManager sharedManager].cinemasArray[section];
    ImageViewTableHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImageViewTableHeader" owner:self options:nil] lastObject];
    headerView.imageView.image = [UIImage imageWithCinemaID:cinema.itemID theaterID:theater.theaterID];
    headerView.textLabel.text = theater.name;
    return headerView;
}


- (void) loadCinemasTheatersFunctionsArray {
    NSMutableArray *theaters = [NSMutableArray new];
    
    for (BasicItemImage *cinema in [FavoritesManager sharedManager].cinemasArray) {
        for (Theater *theater in self.theaterFuctions) {
            if (theater.cinemaID == cinema.itemID) {
                [theaters addObject:theater];
            }
        }
    }
    self.cinemasTheatersFunctions = [NSArray arrayWithArray:theaters];
}

@end
