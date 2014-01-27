//
//  MovieFunctionsShowtimesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieFunctionsVC.h"
#import "MBProgressHUD.h"
#import "Function2.h"
#import "Theater2.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "UIView+CH.h"

@interface MovieFunctionsVC ()
@property (nonatomic, strong) NSArray *theaterFuctions;
@end

@implementation MovieFunctionsVC {
    UIFont *headerFont;
    UIFont *tableFont;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.movieName;
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA FUNCIONES" forKey:kGAIScreenName] build]];
    
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // TopView it's the view over the tableview while it's downloading the data for the first time
    UIView *topView = [[UIView alloc] initWithFrame:self.view.bounds];
    topView.backgroundColor = [UIColor tableViewColor];
    topView.tag = 999;
    [self.view addSubview:topView];
    
    [self downloadMovieFunctions];
}
-(void) downloadMovieFunctions{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Function2 getMovieTheatersFavoritesWithBlock:^(NSArray *theaterFunctions, NSError *error) {
        if (!error) {
            self.theaterFuctions = theaterFunctions;
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
            
            UIView *frontView = [self.view viewWithTag:999];
            [UIView animateWithDuration:0.3 animations:^{
                frontView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                [frontView removeFromSuperview];
                self.tableView.scrollEnabled = YES;
            }];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self downloadMovieFunctions];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
    } movieID:self.movieID theaters:self.theaters];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self downloadMovieFunctions];
}
#pragma mark - Content Size Changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
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
        Theater2 *theater = self.theaterFuctions[indexPath.section];
        Function2 *function = theater.functions[indexPath.row];
        CGSize size = CGSizeMake(280.f, 1000.f);
        
        CGRect typesLabelRect = [function.functionTypes boundingRectWithSize: size
                                                             options: NSStringDrawingUsesLineFragmentOrigin
                                                          attributes: [NSDictionary dictionaryWithObject:tableFont forKey:NSFontAttributeName]
                                                             context: nil];
        CGRect showtimesLabelRect = [function.showtimes boundingRectWithSize: size
                                                                     options: NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes: [NSDictionary dictionaryWithObject:tableFont forKey:NSFontAttributeName]
                                                                     context: nil];
        CGFloat typesHeight = typesLabelRect.size.height;
        if (!function.functionTypes || [function.functionTypes isEqualToString:@""]) {
            typesHeight = 0.;
        }
        CGFloat totalHeight = 10.0f + typesHeight + 5.0f + showtimesLabelRect.size.height + 10.0f;
        
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
    Theater2 *theater = self.theaterFuctions[section];
    return theater.functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Theater2 *theater = self.theaterFuctions[indexPath.section];
    Function2 *function = theater.functions[indexPath.row];
    
    UILabel *functionTypes = (UILabel *)[cell viewWithTag:1];
    UILabel *functionShowtimes = (UILabel *)[cell viewWithTag:2];
    functionTypes.text = function.functionTypes;
    functionShowtimes.text = function.showtimes;
    functionTypes.font = tableFont;
    functionShowtimes.font = tableFont;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    Theater2 *theater = self.theaterFuctions[section];
    
    return [UIView heightForHeaderViewWithText:theater.name font:headerFont];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Theater2 *theater = self.theaterFuctions[section];
    NSInteger height = [UIView heightForHeaderViewWithText:theater.name font:headerFont];
    
    return [UIView headerViewForText:theater.name font:headerFont height:height];
}

@end
