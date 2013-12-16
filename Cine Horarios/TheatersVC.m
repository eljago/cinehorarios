//
//  TheatersViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "TheatersVC.h"
#import "Theater.h"
#import "FuncionesVC.h"
#import "UIColor+CH.h"
#import "FileHandler.h"
#import "UIFont+CH.h"
#import "CHCell.h"
#import "UIColor+CH.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface TheatersVC ()
@property (nonatomic, strong) NSArray *theaters;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation TheatersVC {
    UIFont *tableFont;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"COMPLEJOS" forKey:kGAIScreenName] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Preferencias Usuario"
                                                          action:@"Cines Visitados"
                                                           label:self.cinemaName
                                                           value:nil] build]];
    
    self.title = self.cinemaName;
    
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getTheatersForceRemote:NO];
}
-(void)dealloc {
    self.alert.delegate = nil;
    self.alert = nil;
}

#pragma mark - UITableViewController
#pragma mark Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.theaters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CHCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Theater *theater = self.theaters[indexPath.row];
    cell.basicItem = theater;
    [cell setFont:tableFont];
    
    return cell;
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CHCell heightForCellWithBasicItem:self.theaters[indexPath.row] withFont:tableFont];
}

#pragma mark - TheatersVC
#pragma mark Fetch Data

- (void) getTheatersForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadTheaters];
    }
    else {
        self.theaters = [Theater getLocalTheatersWithCinemaID:self.cinemaID];
        if (self.theaters.count) {
            [self.tableView reloadData];
        }
        else {
            [self downloadTheaters];
        }
    }
}

-(void) downloadTheaters {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Theater getTheatersWithBlock:^(NSArray *theaters, NSError *error) {
        if (!error) {
            self.theaters = theaters;
            [self.tableView reloadData];
        }
        else {
            [self showAlert];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } cinemaID: self.cinemaID];
}

#pragma mark Refresh

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getTheatersForceRemote:YES];
}

#pragma mark AlertView

- (void) showAlert{
    self.alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problema en la Descarga" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reintentar", nil];
    [self.alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self getTheatersForceRemote:YES];
    }
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];

    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FuncionesVC *functionesVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater *theater = self.theaters[indexPath.row];
    functionesVC.theaterName = theater.name;
    functionesVC.theaterID = theater.itemId;
}


@end
