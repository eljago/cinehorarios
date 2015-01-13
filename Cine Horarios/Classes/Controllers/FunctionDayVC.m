//
//  FunctionDayVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionDayVC.h"
#import "CHViewTableController_Protected.h"
#import "Theater.h"
#import "FunctionCell2.h"
#import "FunctionCell2+Function.h"
#import "ArrayDataSource.h"
#import "UIColor+CH.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"
#import "UIView+CH.h"
#import "MovieVC.h"
#import "Function.h"
#import "NSDate+CH.h"
#import "Theater.h"
#import "GAI+CH.h"
#import "FavoritesManager.h"
#import "DOPDropDownMenu.h"
#import "UIViewController+ScrollingNavbar.h"

const CGFloat kDropDownMenuHeight = 40.f;
const NSUInteger kNumberOfDays = 7;

@interface FunctionDayVC () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, assign) BOOL favorite;

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSArray *functions;
@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation FunctionDayVC {
    BOOL viewAppeared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GAI trackPage:@"FUNCIONES"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Complejos Visitados" label:self.theater.name];
    
    self.date = [NSDate date];
    self.title = self.theater.name;
    
    [self setupDataSource];
    [self createButtonItems];
    
    NSArray *genres = @[@"Acción", @"Aventura"];
    NSMutableArray *newDaysNames = [NSMutableArray arrayWithCapacity:kNumberOfDays];
    for (int i=0; i<kNumberOfDays; i++) {
        [newDaysNames addObject:[[self.date datePlusDays:i] getShortDateString]];
    }
    self.menuArray = @[[NSArray arrayWithArray:newDaysNames], genres];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:kDropDownMenuHeight];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [self setupFavorites];
    
    [self getDataForceDownload:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.favoriteButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (viewAppeared) [self setupFavorites];
    viewAppeared = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieVC *movieVC = segue.destinationViewController;
    Function *function = self.theater.functions[indexPath.row];
    movieVC.movieID = function.movieID;
    movieVC.movieName = function.name;
    movieVC.portraitImageURL = function.portraitImageURL;
    movieVC.coverImageURL = function.imageURL;
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.theater.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
        [cell configureForFunction:function];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - Fetch Data

- (void) getDataForceDownload:(BOOL)forceDownload {
    NSLog(@"fetching data ");
    if (forceDownload) {
        [self downloadTheater];
    }
    else {
        Theater *theater = [Theater loadTheaterWithTheaterID:self.theater.theaterID date:self.date];
        if (theater && theater.functions.count > 0) {
            self.theater = theater;
            NSMutableArray *newFunctions = [NSMutableArray new];
            for (Function *function in self.theater.functions) {
                [newFunctions addObject:function];
            }
            self.functions = [NSArray arrayWithArray:newFunctions];
            self.dataSource.items = self.functions;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self downloadTheater];
        }
    }
}
-(void) downloadTheater {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Theater getTheaterWithBlock:^(Theater *theater, NSError *error) {
        if (!error) {
            self.theater = theater;
            if (self.theater.functions.count > 0) {
                NSMutableArray *newFunctions = [NSMutableArray new];
                for (Function *function in self.theater.functions) {
                    [newFunctions addObject:function];
                }
                self.functions = [NSArray arrayWithArray:newFunctions];
                self.dataSource.items = self.functions;
            }
            else {
            }
        }
        else {
            NSLog(@"%@",error.localizedDescription);
        }
        [self.tableView reloadData];
        self.tableView.scrollEnabled = YES;
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } theaterID:self.theater.theaterID date:self.date];
}

- (void) refreshData {
    [self getDataForceDownload:YES];
}

#pragma mark - DOPDropDownMenu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return self.menuArray.count;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return [self.menuArray[column] count];
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return self.menuArray[indexPath.column][indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.functions = [self.theater.functions sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    FunctionCell2 *functionCell2 = (FunctionCell2 *)cell;
    functionCell2.mainLabel.font = self.fontBigBold;
    functionCell2.typesLabel.font = self.fontNormal;
    functionCell2.showtimesLabel.font = self.fontNormal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Function *function = self.functions[indexPath.row];
    return [FunctionCell2 heightForRowWithFunction:function headFont:self.fontBigBold bodyFont:self.fontNormal showtimesFont:self.fontNormal];
}

#pragma mark - Favorites

-(void) createButtonItems {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(0, 0, 40, 40);
    [favoriteButton addTarget:self action:@selector(setFavoriteTheater:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"FavoriteHeart"];
    
    self.favoriteButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(setFavoriteTheater:)];
    self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    self.favoriteButtonItem.enabled = NO;
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];

    self.navigationItem.rightBarButtonItems = @[menuButtonItem, self.favoriteButtonItem];
}

- (void) setupFavorites{
    if ([[FavoritesManager sharedManager] theaterWithTheaterID:self.theater.theaterID]) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
        self.favorite = YES;
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
        self.favorite = NO;
    }
    self.favoriteButtonItem.enabled = YES;
}

- (IBAction) setFavoriteTheater:(id)sender{
    if (self.theater) {
        self.favoriteButtonItem.enabled = NO;
        [[FavoritesManager sharedManager] toggleTheater:self.theater withCompletionBlock:^{
            self.favorite = !self.favorite;
            if (self.favorite) {
                self.favoriteButtonItem.tintColor = [UIColor whiteColor];
            }
            else{
                self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
            }
            self.favoriteButtonItem.enabled = YES;
        }];
    }
}

@end
