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
}
-(void) downloadMovieFunctions{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    
    [Function getMovieTheatersFavoritesWithBlock:^(NSArray *theaterFunctions, NSError *error) {
        if (!error) {
            self.theaterFuctions = theaterFunctions;
            
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 15., 0, 0);

            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cinemaID" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.theaterFuctions = [self.theaterFuctions sortedArrayUsingDescriptors:sortDescriptors];
            [self loadCinemasTheatersFunctionsArray];
            
            [self.tableView reloadData];
        }
        else {
            
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
    
    if (self.theaterFuctions.count) {
        Theater *theater = self.theaterFuctions[indexPath.section];
        Function *function = theater.functions[indexPath.row];
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
    else {
        return 0.01;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cinemasTheatersFunctions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cinemasTheatersFunctions[section][@"Theaters"] count];
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
    return 50.0;
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
    NSMutableArray *cinemasTheatersArray = [NSMutableArray new];
    
    for (BasicItemImage *cinema in [FavoritesManager sharedManager].cinemasArray) {
        NSMutableArray *theaters = [NSMutableArray new];
        for (Theater *theater in self.theaterFuctions) {
            if (theater.cinemaID == cinema.itemID) {
                [theaters addObject:theater];
            }
        }
        [cinemasTheatersArray addObject:theaters];
    }
    [cinemasTheatersArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        if ([dict[@"Theaters"] count] <= 0) {
            [cinemasTheatersArray removeObject:dict];
        }
    }];
    self.cinemasTheatersFunctions = [NSArray arrayWithArray:cinemasTheatersArray];
}

@end
