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
#import "RESideMenu.h"

@interface TheatersVC ()
@property (nonatomic, strong) NSArray *theaters;
@end

@implementation TheatersVC {
    UIFont *tableFont;
}

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.sideMenuViewController action:@selector(presentMenuViewController)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getTheatersForceRemote:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getTheatersForceRemote:YES];
}
- (void) showAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Problema en la Descarga" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reintentar", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self getTheatersForceRemote:YES];
    }
}

#pragma mark - Table view data source

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CHCell heightForCellWithBasicItem:self.theaters[indexPath.row] withFont:tableFont];
}

#pragma mark - content Size Changed

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
