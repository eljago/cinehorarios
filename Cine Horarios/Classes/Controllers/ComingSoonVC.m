//
//  ComingSoonViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonVC.h"
#import "BasicMovie.h"
#import "Billboard.h"
#import "ComingSoonCell2.h"
#import "ComingSoonCell2+BasicMovie.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "FileHandler.h"
#import "MBProgressHUD.h"
#import "GAI+CH.h"
#import "GAIFields.h"
#import "ArrayDataSource.h"
#import "UIViewController+DoAlertView.h"

@interface ComingSoonVC ()
@property (nonatomic, strong) Billboard *billboard;
@property (nonatomic, strong) ArrayDataSource *dataSource;

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@end

@implementation ComingSoonVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    [GAI trackPage:@"PROXIMAMENTE"];
    
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
        
    [self getComingSoonForceDownload:NO];
    
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.billboard.movies cellIdentifier:@"Cell" configureCellBlock:^(ComingSoonCell2 *cell, BasicMovie *basicMovie) {
        [cell configureForBasicMovie:basicMovie];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    ComingSoonCell2 *comingSoonCell = (ComingSoonCell2 *)cell;
    comingSoonCell.mainLabel.font = self.headFont;
    comingSoonCell.debutTitleLabel.font = self.bodyFont;
    comingSoonCell.debutLabel.font = self.bodyFont;
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasicMovie *basicMovie = self.billboard.movies[indexPath.row];
    return [ComingSoonCell2 heightForRowWithBasicMovie:basicMovie headFont:self.headFont bodyFont:self.bodyFont];
}

#pragma mark - ComingSoonVC
#pragma mark Fetch Data


- (void) getComingSoonForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadComingSoon];
    }
    else {
        self.billboard = [Billboard loadComingSoon];
        if (self.billboard && self.billboard.movies.count > 0) {
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
        }
        else {
            [self downloadComingSoon];
        }
    }
}
-(void) downloadComingSoon {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Billboard getComingSoonWithBlock:^(Billboard *billboard, NSError *error) {
        if (!error) {
            self.billboard = billboard;
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getComingSoonForceDownload:YES];
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
    [self getComingSoonForceDownload:YES];
}

#pragma mark - Content Size Changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieVC *movieVC = segue.destinationViewController;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    BasicMovie *basicMovie = self.billboard.movies[row];
    movieVC.movieID = basicMovie.movieID;
    movieVC.movieName = basicMovie.name;
    movieVC.portraitImageURL = basicMovie.portraitImageURL;
    movieVC.coverImageURL = basicMovie.imageURL;
}

@end
