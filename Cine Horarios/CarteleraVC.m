//
//  CarteleraViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CarteleraVC.h"
#import "BasicMovie2.h"
#import "Billboard.h"
#import "BillboardCell.h"
#import "BillboardCell+BasicMovie.h"
#import "Genre.h"
#import "NSArray+FKBMap.h"
#import "UIFont+CH.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ArrayDataSource.h"

@interface CarteleraVC ()
@property (nonatomic, strong) Billboard *billboard;
@property (nonatomic, strong) ArrayDataSource *dataSource;

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@end

@implementation CarteleraVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"CARTELERA" forKey:kGAIScreenName] build]];
    
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
        
    [self getBillboard];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.billboard.movies cellIdentifier:@"Cell" configureCellBlock:^(BillboardCell *cell, BasicMovie2 *basicMovie) {
        [cell configureForBasicMovie:basicMovie];
    }];
    self.tableView.dataSource = self.dataSource;
}
- (void) getBillboard {
    self.billboard = [Billboard loadBillboard];
    if (self.billboard) {
        self.dataSource.items = self.billboard.movies;
        [self.tableView reloadData];
    }
    else {
        [self downloadBillboard];
    }
}
-(void) downloadBillboard {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Billboard getBillboardWithBlock:^(Billboard *billboard, NSError *error) {
        if (!error) {
            self.billboard = billboard;
            self.dataSource.items = self.billboard.movies;
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getBillboard];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark Refresh
-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getBillboard];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BillboardCell *billboardCell = (BillboardCell *)cell;
    billboardCell.mainLabel.font = self.headFont;
    billboardCell.genresLabel.font = self.bodyFont;
    billboardCell.durationLabel.font = self.bodyFont;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BasicMovie2 *basicMovie = self.billboard.movies[indexPath.row];
    NSArray *genresNames = [basicMovie.genres fkbMap:^NSString *(Genre *genre) {
        return genre.name;
    }];
    NSString *genres = [genresNames componentsJoinedByString:@", "];
    NSString *duration = [NSString stringWithFormat:@"%d", basicMovie.duration];
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [basicMovie.name boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:self.headFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect typesLabelRect = [genres boundingRectWithSize: size
                                                            options: NSStringDrawingUsesLineFragmentOrigin
                                                         attributes: [NSDictionary dictionaryWithObject:self.bodyFont forKey:NSFontAttributeName]
                                                            context: nil];
    CGRect showtimesLabelRect = [duration boundingRectWithSize: size
                                                                  options: NSStringDrawingUsesLineFragmentOrigin
                                                               attributes: [NSDictionary dictionaryWithObject:self.bodyFont forKey:NSFontAttributeName]
                                                                  context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 15.0f + typesLabelRect.size.height + 5.0f + showtimesLabelRect.size.height + 10.0f;
    
    if (totalHeight <= 140.f) {
        totalHeight = 140.f;
    }
    
    return totalHeight;
}

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieVC *movieVC = segue.destinationViewController;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    BasicMovie2 *movie = self.billboard.movies[row];
    movieVC.movieID = movie.movieID;
    movieVC.movieName = movie.name;
    movieVC.portraitImageURL = movie.portraitImageURL;
}

@end
