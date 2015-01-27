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
#import "MovieViewController.h"
#import "Function.h"
#import "Theater.h"
#import "EmptyDataView.h"
#import "WebVC.h"
#import "UIViewController+WebOpener.h"

const NSUInteger kNumberOfDays = 7;

@interface FunctionDayVC () <UIActionSheetDelegate>

@property (nonatomic, strong) ArrayDataSource *dataSource;

@property (nonatomic, strong) EmptyDataView *emptyDataView;

@end

@implementation FunctionDayVC {
    BOOL viewAppeared;
    CGFloat headerHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieViewController *movieViewController = segue.destinationViewController;
    Function *function = self.theater.functions[indexPath.row];
    movieViewController.movieID = function.movieID;
    movieViewController.movieName = function.name;
    movieViewController.portraitImageURL = function.portraitImageURL;
    movieViewController.coverImageURL = function.imageURL;
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.theater.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
        [cell configureForFunction:function];
    }];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - Fetch Data

- (void) getDataForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadTheater];
    }
    else {
        if (self.downloadStatus == CHDownloadStatFailed || self.downloadStatus == CHDownloadStatNoDataFound) {
            [self showEmptyDataView];
            return;
        }
        Theater *theater = [Theater loadTheaterWithTheaterID:self.theater.theaterID date:self.date];
        if (theater) {
            self.theater = theater;
            if (theater.functions.count > 0) {
                self.dataSource.items = self.theater.functions;
            }
            else {
                [self downloadEndedWithDownloadStatus:CHDownloadStatNoDataFound];
                [self showEmptyDataView];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self downloadTheater];
        }
    }
}
-(void) downloadTheater {
    self.emptyDataView.buttonReload.enabled = NO;
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Theater getTheaterWithBlock:^(Theater *theater, NSError *error) {
        if (!error) {
            self.theater = theater;
            if (self.theater.functions.count > 0) {
                self.dataSource.items = self.theater.functions;
                [self downloadEndedWithDownloadStatus:CHDownloadStatSuccessful];
                [self hideEmptyDataView];
            }
            else {
                [self downloadEndedWithDownloadStatus:CHDownloadStatNoDataFound];
                [self showEmptyDataView];
            }
        }
        else {
            [self downloadEndedWithDownloadStatus:CHDownloadStatFailed];
            [self showEmptyDataView];
        }
        [self.tableView reloadData];
        self.tableView.scrollEnabled = YES;
        [self.refreshControl endRefreshing];
        self.emptyDataView.buttonReload.enabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } theaterID:self.theater.theaterID date:self.date];
}

- (void) refreshData {
    [self getDataForceDownload:YES];
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView headerViewForText:self.title height:[UIView heightForHeaderViewWithText:self.title] textAlignment:NSTextAlignmentCenter];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIView heightForHeaderViewWithText:self.title];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    FunctionCell2 *functionCell2 = (FunctionCell2 *)cell;
    functionCell2.mainLabel.font = self.fontBigBold;
    functionCell2.typesLabel.font = self.fontNormal;
    functionCell2.showtimesLabel.font = self.fontNormal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Function *function = self.theater.functions[indexPath.row];
    return headerHeight = [FunctionCell2 heightForRowWithFunction:function headFont:self.fontBigBold bodyFont:self.fontNormal showtimesFont:self.fontNormal];
}

#pragma mark - EmptyDataView

- (EmptyDataView *)emptyDataView
{
    if (!_emptyDataView)
    {
        _emptyDataView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyDataView" owner:self options:nil] firstObject];
        _emptyDataView.backgroundColor = [UIColor tableViewColor];
        CGRect frame = self.tableView.frame;
        frame.origin.y = [UIView heightForHeaderViewWithText:self.title];
        _emptyDataView.frame = frame;
        [_emptyDataView.buttonReload addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
        [_emptyDataView.buttonGoWebPage addTarget:self action:@selector(goTheaterWeb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyDataView;
}

- (void) showEmptyDataView {
    [self reloadEmptyDataViewData];
    [self.tableView addSubview:self.emptyDataView];
}
- (void) hideEmptyDataView {
    [self.emptyDataView removeFromSuperview];
}

- (void) reloadEmptyDataViewData {
    switch (self.downloadStatus) {
        case CHDownloadStatFailed:
            self.emptyDataView.titleLabel.text = @"Ocurrió un problema con la descarga";
            self.emptyDataView.labelButtonReload.text = @"Reintentar Descarga";
            break;
            
        case CHDownloadStatNoDataFound:
            self.emptyDataView.titleLabel.text = @"Aún no tenemos horarios disponibles para este día";
            self.emptyDataView.labelButtonReload.text = @"Volver a Descargar";
            break;
            
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate

- (void) goTheaterWeb {
    [self goWebPageWithUrlString:self.theater.webURL imdbAppUrlString:nil];
}

@end
