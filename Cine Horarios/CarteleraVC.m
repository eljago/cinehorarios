//
//  CarteleraViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CarteleraVC.h"
#import "BasicMovie.h"
#import "CarteleraCell.h"
#import "UIColor+CH.h"
#import "FileHandler.h"
#import "UIFont+CH.h"
#import "Movie.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface CarteleraVC ()
@property (nonatomic, strong) NSArray *movies;
@end

@implementation CarteleraVC {
    UIFont *headFont;
    UIFont *bodyFont;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"CARTELERA" forKey:kGAIScreenName] build]];
    
    headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
        
    [self getCarteleraForceRemote:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getCarteleraForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadCartelera];
    }
    else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.movies = [BasicMovie getLocalCartelera];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (self.movies.count) {
                    [self.tableView reloadData];
                }
                else {
                    [self downloadCartelera];
                }
            });
        });
    }
}

- (void) downloadCartelera {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BasicMovie getCarteleraWithBlock:^(NSArray *movies, NSError *error) {
        if (!error) {
            self.movies = movies;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getCarteleraForceRemote:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getCarteleraForceRemote:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CarteleraCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BasicMovie *basicMovie = self.movies[indexPath.row];
    cell.basicMovie = basicMovie;
    [cell setBodyFont:bodyFont headFont:headFont];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CarteleraCell heightForCellWithBasicItem:self.movies[indexPath.row] withBodyFont:bodyFont headFont:headFont];
}

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieVC *movieVC = segue.destinationViewController;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    BasicMovie *movie = self.movies[row];
    movieVC.movieID = movie.itemId;
    movieVC.movieName = movie.name;
    movieVC.portraitImageURL = movie.portraitImageURL;
}
@end
