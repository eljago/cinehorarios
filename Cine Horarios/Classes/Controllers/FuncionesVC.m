//
//  FuncionesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FuncionesVC.h"
#import "FavoritesVC.h"
#import "FunctionCell2.h"
#import "Theater.h"
#import "Function.h"
#import "MovieVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"
#import "WebVC.h"
#import "UIView+CH.h"
#import "ArrayDataSource.h"
#import "FunctionCell2+Function.h"
#import "UIViewController+DoAlertView.h"

#import "DoAlertView.h"
#import "AnnotationTheater.h"

#import "UIImage+CH.h"

#import "FunctionsPageVC.h"

#import "UIScrollView+EmptyDataSet.h"

#import "FunctionsContainerVC.h"

NSString *const kHeaderString = @"No se han encontrado los horarios.";

@interface FuncionesVC () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) Theater *theater;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, assign) BOOL shouldShowEmptyDataSet;
@end

@implementation FuncionesVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getTheaterForceDownload:NO];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.theater.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
        [cell configureForFunction:function];
    }];
    self.tableView.dataSource = self.dataSource;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    FunctionCell2 *functionCell = (FunctionCell2 *)cell;
    functionCell.mainLabel.font = self.functionsPageVC.headFont;
    functionCell.typesLabel.font = self.functionsPageVC.headFont;
    functionCell.showtimesLabel.font = self.functionsPageVC.showtimesFont;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSInteger height = [UIView heightForHeaderViewWithText:self.functionsPageVC.functionsContainerVC.theaterName];
    return [UIView headerViewForText:self.functionsPageVC.functionsContainerVC.theaterName height:height];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIView heightForHeaderViewWithText:self.functionsPageVC.functionsContainerVC.theaterName];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Function *function = self.theater.functions[indexPath.row];
    return [FunctionCell2 heightForRowWithFunction:function headFont:self.functionsPageVC.headFont bodyFont:self.functionsPageVC.bodyFont showtimesFont:self.functionsPageVC.showtimesFont];
}

#pragma mark - FuncionesVC
#pragma mark Fetch Data

- (void) getTheaterForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadTheater];
    }
    else {
        NSDate *date = [self datePlusDays:self.pageIndex];
        self.theater = [Theater loadTheaterithTheaterID:self.functionsPageVC.functionsContainerVC.theaterID date:date];
        if (self.theater.functions.count > 0) {
            self.dataSource.items = self.theater.functions;
            [self.tableView reloadData];
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            [self downloadTheater];
        }
    }
}

-(void) downloadTheater {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    NSDate *date = [self datePlusDays:self.pageIndex];
    [Theater getTheaterWithBlock:^(Theater *theater, NSError *error) {
        if (!error) {
            self.theater = theater;
            if (self.theater && self.theater.functions.count > 0) {
                self.dataSource.items = self.theater.functions;
            }
            else {
                self.shouldShowEmptyDataSet = YES;
//                [self alertWithTitle:@"Horarios no disponibles" body:[NSString stringWithFormat:@"¿Visitar página web de %@?",self.theater.name] completeBlock:^{
//                    WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
//                    wvc.urlString = self.theater.webURL;
//                    [self.navigationController pushViewController:wvc animated:YES];
//                }];
            }
        }
        else {
            self.shouldShowEmptyDataSet = YES;
            [self alertRetryWithCompleteBlock:^{
                [self getTheaterForceDownload:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    } theaterID:self.functionsPageVC.functionsContainerVC.theaterID date:date];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getTheaterForceDownload:YES];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieVC *movieVC = segue.destinationViewController;
    Function *function = self.theater.functions[indexPath.row];
    movieVC.movieID = function.movieID;
    movieVC.movieName = function.name;
    movieVC.portraitImageURL = function.portraitImageURL;
    movieVC.coverImageURL = function.imageURL;
}

- (void)showTheaterInfo {
    AnnotationTheater *annotationTheater = [[AnnotationTheater alloc] initWithTheater:self.theater];
    UIImage *annotationImage = [UIImage imageWithCinemaID:self.theater.cinemaID theaterID:self.theater.theaterID];
    
    DoAlertView *alertView = [[DoAlertView alloc] init];
    alertView.annotation = annotationTheater;
    alertView.iImage = annotationImage;
    alertView.nAnimationType = DoTransitionStylePop;
    alertView.dRound = 2.0;
    alertView.bDestructive = NO;
    
    alertView.nContentMode = DoContentMap;
    alertView.dLocation = @{@"latitude" : self.theater.latitude, @"longitude" : self.theater.longitude, @"altitude" : @200};
    [alertView doYesNo:@"Title"
                body:@"Here’s a snippet of code that illustrates how the whole process works"
                 yes:^(DoAlertView *alertView) {
                     
                     NSLog(@"Yeeeeeeeeeeeees!!!!");
                     
                 } no:^(DoAlertView *alertView) {
                     
                     NSLog(@"Noooooooooooooo!!!!");
                     
                 }];

}



#pragma mark - Get Functions Date


-(NSDate *)datePlusDays:(NSInteger)days {
    return [[NSDate date] dateByAddingTimeInterval:60*60*24*days];
}


#pragma mark - Empty Data Set DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Please Allow Photo Access";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
    
    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"LogoImdb"];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor whiteColor];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return self.shouldShowEmptyDataSet;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    
    return NO;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    NSLog(@"Data Set Tapped");
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    NSLog(@"Data Set Button Tapped");
}

@end

