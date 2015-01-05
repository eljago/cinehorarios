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

@interface FunctionDayVC () <UITableViewDelegate>

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) NSArray *functions;


@end

@implementation FunctionDayVC

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
    MovieVC *movieVC = segue.destinationViewController;
    Function *function = self.functions[indexPath.row];
    movieVC.movieID = function.movieID;
    movieVC.movieName = function.name;
    movieVC.portraitImageURL = function.portraitImageURL;
    movieVC.coverImageURL = function.imageURL;
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
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
        Theater *theater = [Theater loadTheaterWithTheaterID:self.theaterID date:self.date];
        if (theater && theater.functions.count > 0) {
            self.functions = theater.functions;
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
            self.functions = theater.functions;
            if (self.functions.count > 0) {
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
    } theaterID:self.theaterID date:self.date];
}

- (void) refreshData {
    [self getDataForceDownload:YES];
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView headerViewForText:self.theaterName height:-1];
}

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

@end
