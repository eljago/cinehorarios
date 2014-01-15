//
//  ComingSoonViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonVC.h"
#import "BasicMovie.h"
#import "ComingSoonCell.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "FileHandler.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface ComingSoonVC ()
@property (nonatomic, strong) NSArray *movies;
@end

@implementation ComingSoonVC {
    UIFont *headFont;
    UIFont *bodyFont;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PROXIMAMENTE" forKey:kGAIScreenName] build]];
    
    headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
        
    [self getComingSoonForceRemote:NO];
    
}

#pragma mark - UITableViewController
#pragma mark Data Source

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
    ComingSoonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BasicMovie *basicMovie = self.movies[indexPath.row];
    cell.basicMovie = basicMovie;
    [cell setBodyFont:bodyFont headFont:headFont];
    
    return cell;
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ComingSoonCell heightForCellWithBasicItem:self.movies[indexPath.row] withBodyFont:bodyFont headFont:headFont];
}

#pragma mark - ComingSoonVC
#pragma mark Fetch Data

- (void) getComingSoonForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadComingSoon];
    }
    else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.movies = [BasicMovie getLocalComingSoon];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (self.movies.count) {
                    [self.tableView reloadData];
                }
                else {
                    [self downloadComingSoon];
                }
            });
        });
    }
}

- (void) downloadComingSoon {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BasicMovie getComingSoonWithBlock:^(NSArray *movies, NSError *error) {
        if (!error) {
            self.movies = movies;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getComingSoonForceRemote:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark Refresh

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getComingSoonForceRemote:YES];
}

#pragma mark - Content Size Changed
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
