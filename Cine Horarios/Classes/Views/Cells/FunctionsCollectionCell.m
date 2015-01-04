//
//  FunctionsCollectionCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 31-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsCollectionCell.h"
#import "Theater.h"
#import "Function.h"
#import "FunctionCell2.h"
#import "FunctionCell2+Function.h"
#import "ArrayDataSource.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"
#import "UIColor+CH.h"

#import "FunctionsTableView.h"


@interface FunctionsCollectionCell ()
@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) CGFloat contentWidth;
@end

@implementation FunctionsCollectionCell

-(void) awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor tableViewColor];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor blackColor];
    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void) setupDataSource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.functions cellIdentifier:@"Cell" configureCellBlock:^(FunctionCell2 *cell, Function *function) {
        [cell configureForFunction:function];
    }];
    self.tableView.dataSource = self.dataSource;
}

- (void) prepareCell {
    [self setupDataSource];
    self.dataSource.items = self.functions;
}

- (void) getDataForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadTheater];
    }
    else {
        Theater *theater = [Theater loadTheaterWithTheaterID:self.theaterID date:self.date];
        if (theater && theater.functions.count > 0) {
            [self.functions removeAllObjects];
            [self.functions addObjectsFromArray:theater.functions];
            self.dataSource.items = self.functions;
            self.tableView.hidden = NO;
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
    [MBProgressHUD showHUDAddedTo:self animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Theater getTheaterWithBlock:^(Theater *theater, NSError *error) {
        if (!error) {
            [self.functions removeAllObjects];
            [self.functions addObjectsFromArray:theater.functions];
            if (self.functions.count > 0) {
                self.dataSource.items = self.functions;
                self.tableView.hidden = NO;
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
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    } theaterID:self.theaterID date:self.date];
}

- (void) refreshData {
    [self getDataForceDownload:YES];
}

#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Function *function = self.functions[indexPath.row];
    return [FunctionCell2 heightForRowWithFunction:function headFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] bodyFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] showtimesFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [[self delegate] tableCellDidSelect:cell];
}

@end
