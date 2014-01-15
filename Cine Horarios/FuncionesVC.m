//
//  FuncionesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FuncionesVC.h"
#import "FavoritesVC.h"
#import "FunctionCell.h"
#import "BasicMovie.h"
#import "UIColor+CH.h"
#import "Function.h"
#import "FileHandler.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "WebVC.h"
#import "UIView+CH.h"

NSString *const kHeaderString = @"No se han encontrado los horarios.";

@interface FuncionesVC ()
@property (nonatomic, strong) NSArray *functions;
@property (nonatomic, strong) NSString *theater_url;
@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, strong) UIBarButtonItem *menuButtonItem;
@end

@implementation FuncionesVC{
    UIFont *headFont;
    UIFont *bodyFont;
    BOOL favorite;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"FUNCIONES" forKey:kGAIScreenName] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Preferencias Usuario"
                                                          action:@"Complejos Visitados"
                                                           label:self.theaterName
                                                           value:nil] build]];
    
    headFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self createButtonItems];
    [self setupFavorites];
    
    [self getFunctionsForceRemote:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupFavorites];
}

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.functions.count > 0) {
        return self.functions.count;
    }
    else {
        if (self.theater_url) {
            return 1;
        }
        else {
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.functions.count > 0) {
        static NSString *CellIdentifier = @"Cell";
        FunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.function = self.functions[indexPath.row];
        [cell setBodyFont:bodyFont headFont:headFont];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell2";
        FunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Ir a la página web de %@", self.theaterName];
        
        return cell;
    }
}

#pragma mark Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.functions.count > 0) {
        NSInteger height = [UIView heightForHeaderViewWithText:self.theaterName font:headFont];
        return [UIView headerViewForText:self.theaterName font:headFont height:height];
    }
    else {
        if (self.theater_url) {
            NSInteger height = [UIView heightForHeaderViewWithText:kHeaderString font:headFont];
            return [UIView headerViewForText:kHeaderString font:headFont height:height];
        }
        else {
            return [UIView new];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.functions.count > 0) {
        return [UIView heightForHeaderViewWithText:self.theaterName font:headFont];
    }
    else {
        return [UIView heightForHeaderViewWithText:kHeaderString font:headFont];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.functions.count > 0) {
        return [FunctionCell heightForCellWithBasicItem:self.functions[indexPath.row] withBodyFont:bodyFont headFont:headFont];
    }
    else {
        return [self heightForRowWithText:[NSString stringWithFormat:@"Ir a la página web de %@", self.theaterName]];
    }
}

#pragma mark - FuncionesVC
#pragma mark Row & Header Height Calculators

-(CGFloat) heightForRowWithText:(NSString *)text {
    CGSize size = CGSizeMake(270.f, 1000.f);
    
    CGRect nameLabelRect = [text boundingRectWithSize: size
                                              options: NSStringDrawingUsesLineFragmentOrigin
                                           attributes: [NSDictionary dictionaryWithObject:bodyFont
                                                                                   forKey:NSFontAttributeName]
                                              context: nil];
    
    CGFloat totalHeight = nameLabelRect.size.height * 1.2;
    
    if (totalHeight <= 25.f) {
        totalHeight = 25.f;
    }
    
    return totalHeight;
}

#pragma mark Fetch Data

- (void) getFunctionsForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadFunctions];
    }
    else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",[components year], [components month], [components day]];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.functions = [Function getLocalFunctionsWithTheaterID:self.theaterID dateString:dateString];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (self.functions.count) {
                    [self.tableView reloadData];
                }
                else {
                    [self downloadFunctions];
                }
            });
        });
    }
}

-(void) downloadFunctions {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Function getFunctionsWithBlock:^(NSArray *functions, NSString *theater_url, NSError *error) {
        if (!error) {
            self.functions = functions;
            self.theater_url = theater_url;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getFunctionsForceRemote:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } theaterID: self.theaterID date:[NSDate date]];
}

#pragma mark Refresh

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getFunctionsForceRemote:YES];
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
        favorite = YES;
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
        favorite = NO;
    }
}

- (IBAction) setFavoriteTheater:(id)sender{
    favorite = !favorite;
    if (favorite) {
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
    headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FunctionsToMovie"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MovieVC *movieVC = segue.destinationViewController;
        Function *function = self.functions[indexPath.row];
        movieVC.movieID = function.itemId;
        movieVC.movieName = function.name;
        movieVC.portraitImageURL = function.portraitImageURL;
    }
    else {
        WebVC *wvc = segue.destinationViewController;
        wvc.urlString = self.theater_url;
    }
}

@end
