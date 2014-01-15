//
//  MovieFunctionsViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCinemasVC.h"
#import "UIImageView+AFNetworking.h"
#import "Theater.h"
#import "MovieFunctionsVC.h"
#import "Movie.h"
#import "MBProgressHUD.h"
#import "BasicItem.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "UIView+CH.h"

@interface MovieCinemasVC ()
@property (nonatomic, strong) NSMutableArray *favoriteTheaters;
@property (nonatomic, strong) NSMutableArray *cinemas;
@property (nonatomic, strong) NSMutableArray *theaters;
@end

@implementation MovieCinemasVC {
    UIFont *headerFont;
    UIFont *tableFont;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA CINES" forKey:kGAIScreenName] build]];
    
    self.title = @"Buscar Horarios";
    
    // loads favorite theaters
    [self loadFavorites];
    
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    [self getMovieTheatersForceRemote:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getMovieTheatersForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadShowTheaters];
    }
    else {
        NSArray *theaters = [Theater getLocalMovieTheatersWithMovieID:self.movieID];
        if (theaters.count) {
            [self loadCinemas];
            [self makeArraysUsingTheaters:theaters];
            [self.tableView reloadData];
        }
        else {
            [self downloadShowTheaters];
        }
    }
}
-(void) downloadShowTheaters{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Theater getMovieTheatersWithBlock:^(NSArray *theaters, NSError *error) {
        if (!error) {
            [self loadCinemas];
            [self makeArraysUsingTheaters:theaters];
            
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getMovieTheatersForceRemote:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } movieID:self.movieID];
}
- (void) makeArraysUsingTheaters:(NSArray *)theaters {
    self.theaters = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], [NSMutableArray array], nil];
    for (Theater *theater in theaters) {
        for (Theater *favTheater in self.favoriteTheaters) {
            if (favTheater.itemId == theater.itemId) {
                [self.theaters[0] addObject:theater];
                break;
            }
        }
        int i = 0;
        for (BasicImageItem *cinema in self.cinemas) {
            if (cinema.itemId == theater.cinemaID) {
                [self.theaters[i] addObject:theater];
            }
            i++;
        }
    }
    int i = 0;
    NSMutableArray *newTheaters = [NSMutableArray array];
    NSMutableArray *newCinemas = [NSMutableArray array];
    for (NSArray *array in self.theaters) {
        if (array.count > 0) {
            [newTheaters addObject:array];
            [newCinemas addObject:self.cinemas[i]];
        }
        i++;
    }
    self.theaters = newTheaters;
    self.cinemas = newCinemas;
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getMovieTheatersForceRemote:YES];
}

- (void) loadFavorites {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icloud.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSDictionary *favorites = [dict valueForKey:@"Favorites"];
        self.favoriteTheaters = [[NSMutableArray alloc] initWithCapacity:[favorites count]];
        NSArray *keys = [favorites allKeys];
        NSArray *values = [favorites allValues];
        for (int i=0;i<[favorites count];i++){
            BasicItem *theater = [[BasicItem alloc] initWithId:[[keys objectAtIndex:i] integerValue] name:[values objectAtIndex:i]];
            [self.favoriteTheaters insertObject:theater atIndex:i];
        }
    }
    else {
        self.favoriteTheaters = [NSMutableArray array];
    }
}

- (void) loadCinemas {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cinemas" ofType:@"plist"];
    NSArray *cinemasLocal = [NSArray arrayWithContentsOfFile:filePath];
    self.cinemas = [NSMutableArray array];
    
    [self.cinemas addObject:[[BasicImageItem alloc] initWithId:100 name:@"Favoritos" imageUrl:@"FavoriteHeart"]];
    for (NSDictionary *dict in cinemasLocal) {
        [self.cinemas addObject:[[BasicImageItem alloc] initWithId:[dict[@"id"] integerValue] name:dict[@"name"] imageUrl:dict[@"image"]]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cinemas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:101];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    BasicImageItem *cinema = self.cinemas[indexPath.row];
    labelName.text = cinema.name;
    labelName.font = tableFont;
    if ([cinema.imageUrl isEqualToString:@""]) {
        imageView.image = nil;
    }
    else {
        imageView.image = [UIImage imageNamed:cinema.imageUrl];
    }
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.movieName;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderView];
}
-(CGFloat) heightForHeaderView {
    CGSize size = CGSizeMake(300.f, 1000.f);
    
    CGRect nameLabelRect = [self.movieName boundingRectWithSize: size
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: [NSDictionary dictionaryWithObject:headerFont
                                                                                        forKey:NSFontAttributeName]
                                                   context: nil];
    
    CGFloat totalHeight = nameLabelRect.size.height * 1.2;
    
    if (totalHeight <= 25.f) {
        totalHeight = 25.f;
    }
    
    return totalHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.cinemas.count) {
        UIView *view = [UIView headerViewForText:self.movieName font:headerFont height:[self heightForHeaderView]];
        UILabel *label = (UILabel *)[view viewWithTag:40];
        label.numberOfLines = 0;
        return view;
    }
    else {
        return [UIView new];
    }
}

#pragma mark - content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MovieShowtimesToMovieFunctions"]) {
        NSInteger row = [self.tableView indexPathForCell:sender].row;
        MovieFunctionsVC *vc = (MovieFunctionsVC *)segue.destinationViewController;
        vc.theaters = self.theaters[row];
        vc.movieID = self.movieID;
        vc.movieName = self.movieName;
    }
}

@end
