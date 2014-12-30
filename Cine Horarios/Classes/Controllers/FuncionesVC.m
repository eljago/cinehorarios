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

#import "AnnotationTheater.h"

#import "UIImage+CH.h"

#import "FunctionsPageVC.h"

#import "UIScrollView+EmptyDataSet.h"

#import "FunctionsContainerVC.h"

#import "OpenInChromeController.h"

#import "UIColor+CH.h"

NSString *const kHeaderString = @"No se han encontrado los horarios.";

NSString *const kFunctionsDownloaded = @"DOWNLOADED";
NSString *const kFunctionsFailedDownload = @"FAILED DOWNLOAD";

@interface FuncionesVC () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, assign) BOOL shouldShowEmptyDataSet;
@property (nonatomic, strong) OpenInChromeController *openInChromeController;
@end

@implementation FuncionesVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.openInChromeController = [[OpenInChromeController alloc] init];
    
    [self setupDataSource];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
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

    NSInteger height = [UIView heightForHeaderViewWithText:self.functionsPageVC.functionsContainerVC.theater.name];
    return [UIView headerViewForText:[self.dateString capitalizedString] textAlignment:NSTextAlignmentCenter height:height];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIView heightForHeaderViewWithText:self.functionsPageVC.functionsContainerVC.theater.name];
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
        CHDownloadStatus downloadStatus = [self.functionsPageVC getDownloadStatusForIndex:self.pageIndex];
        NSDate *date = [self datePlusDays:self.pageIndex];
        switch (downloadStatus) {
                
            case CHDownloadStatusNotDownloaded:
                self.theater = [Theater loadTheaterWithTheaterID:self.functionsPageVC.functionsContainerVC.theater.theaterID date:date];
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
                break;
                
            case CHDownloadStatusFailedDownload:
                self.shouldShowEmptyDataSet = YES;
                [self.tableView reloadData];
                self.tableView.scrollEnabled = YES;
                break;
                
            case CHDownloadStatusDownloadSuccessful:
                self.theater = [Theater loadTheaterWithTheaterID:self.functionsPageVC.functionsContainerVC.theater.theaterID date:date];
                if (self.theater.functions.count > 0) {
                    self.dataSource.items = self.theater.functions;
                    if (self.refreshControl.refreshing) {
                        [self.refreshControl endRefreshing];
                    }
                }
                else {
                    self.shouldShowEmptyDataSet = YES;
                    self.tableView.scrollEnabled = YES;
                }
                [self.tableView reloadData];
                break;
                
            default:
                break;
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
                [self.functionsPageVC setDownloadStatus:CHDownloadStatusDownloadSuccessful atIndex:self.pageIndex];
                self.dataSource.items = self.theater.functions;
            }
            else {
                [self.functionsPageVC setDownloadStatus:CHDownloadStatusDownloadSuccessful atIndex:self.pageIndex];
                self.shouldShowEmptyDataSet = YES;
            }
        }
        else {
            [self.functionsPageVC setDownloadStatus:CHDownloadStatusFailedDownload atIndex:self.pageIndex];
            self.shouldShowEmptyDataSet = YES;
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    } theaterID:self.functionsPageVC.functionsContainerVC.theater.theaterID date:date];
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

#pragma mark - Get Functions Date


-(NSDate *)datePlusDays:(NSInteger)days {
    return [[NSDate date] dateByAddingTimeInterval:60*60*24*days];
}


#pragma mark - Empty Data Set DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Aún no tenemos disponibles los horarios de este día";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"¿Quiere visitar la página web de este cine?";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:@"Visitar" attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"Ghost"];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor tableViewColor];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return self.shouldShowEmptyDataSet;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    
    return YES;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {

}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    NSString *actionSheetTitle = @"Abrir enlace en:";
    NSString *cancelTitle = @"Cancelar";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"App", @"Safari", nil];
    
    if ([self.openInChromeController isChromeInstalled]) {
        [actionSheet addButtonWithTitle:@"Chrome"];
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"App"]) {
        WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
        wvc.urlString = self.functionsPageVC.functionsContainerVC.theater.webURL;
        [self.navigationController pushViewController:wvc animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Safari"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.functionsPageVC.functionsContainerVC.theater.webURL]];
    }
    else if ([buttonTitle isEqualToString:@"Chrome"]) {
        if ([self.openInChromeController isChromeInstalled]) {
            [self.openInChromeController openInChrome:[NSURL URLWithString:self.functionsPageVC.functionsContainerVC.theater.webURL]
                                      withCallbackURL:nil
                                         createNewTab:YES];
        }
    }
}

@end

