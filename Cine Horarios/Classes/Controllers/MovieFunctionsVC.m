//
//  MovieFunctionsShowtimesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieFunctionsVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"
#import "Function.h"
#import "Theater.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "GAI+CH.h"
#import "UIView+CH.h"
#import "BasicItemImage.h"
#import "UIImage+CH.h"
#import "ImageViewTableHeader.h"

@interface MovieFunctionsVC ()
@property (nonatomic, strong) NSMutableArray *favoriteTheaters;
@property (nonatomic, strong) NSArray *theaterFuctions;
@property (nonatomic, strong) NSMutableArray *cinemas;
@property (nonatomic, strong) UIFont *tableFont;
@property (nonatomic, strong) UIFont *showtimesFonts;
@end

@implementation MovieFunctionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.movieName;
    
    [GAI trackPage:@"PELICULA FUNCIONES"];
    
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleNormalBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.showtimesFonts = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, self.view.bounds.size.width, 0, 0);
    
    [self loadCinemas];
    // loads favorite theaters
    [self loadFavorites];
    
    if (self.favoriteTheaters.count > 0) {
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
            
            [self.tableView reloadData];
        }
        else {
            
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
    } movieID:self.movieID theaters:self.favoriteTheaters];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self downloadMovieFunctions];
}
#pragma mark - Content Size Changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleNormalBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.showtimesFonts = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [self.tableView reloadData];
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
                                                          attributes: [NSDictionary dictionaryWithObject:self.tableFont forKey:NSFontAttributeName]
                                                             context: nil];
        CGRect showtimesLabelRect = [function.showtimes boundingRectWithSize: size
                                                                     options: NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes: [NSDictionary dictionaryWithObject:self.showtimesFonts forKey:NSFontAttributeName]
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
    return self.theaterFuctions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Theater *theater = self.theaterFuctions[section];
    return theater.functions.count;
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
    functionTypes.font = self.tableFont;
    functionShowtimes.font = self.showtimesFonts;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Theater *theater = self.theaterFuctions[section];
    BasicItemImage *cinema = self.cinemas[section];
    ImageViewTableHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImageViewTableHeader" owner:self options:nil] lastObject];
    headerView.imageView.image = [UIImage imageWithCinemaID:cinema.itemID theaterID:theater.theaterID];
    headerView.textLabel.text = theater.name;
    return headerView;
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
            NSDictionary *theaterDictionary = @{@"theaterID": [NSNumber numberWithInt:[[keys objectAtIndex:i] intValue]],
                                                @"name": [values objectAtIndex:i]};
            Theater *theater = [[Theater alloc] initWithDictionary:theaterDictionary error:NULL];
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
    
    for (NSDictionary *dict in cinemasLocal) {
        BasicItemImage *cinema = [MTLJSONAdapter modelOfClass:BasicItem.class fromJSONDictionary:dict error:NULL];
        [self.cinemas addObject:cinema];
    }
}

@end
