//
//  CHViewTableController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"
#import "CHViewTableController_Protected.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"

@interface CHViewTableController () {
    @protected
    UIFont *fontNormal;
    UIFont *fontBigBold;
    UIFont *fontSmall;
    UITableView *tableView;
    UIRefreshControl *refreshControl;
    NSLayoutConstraint *topLayoutConstraint;
}

@end

@implementation CHViewTableController
@synthesize tableView = _tableView;
@synthesize fontNormal = _fontNormal;
@synthesize fontBigBold = _fontBigBold;
@synthesize fontSmall = _fontSmall;
@synthesize refreshControl = _refreshControl;
@synthesize topLayoutConstraint = _topLayoutConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    self.view.backgroundColor = [UIColor tableViewColor];
    //    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor blackColor];
    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Attributes
- (UIFont *) fontNormal {
    if(_fontNormal) return _fontNormal;
    _fontNormal = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontNormal;
}
- (UIFont *) fontBigBold {
    if(_fontBigBold) return _fontBigBold;
    _fontBigBold = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontBigBold;
}
- (UIFont *) fontSmall {
    if(_fontSmall) return _fontSmall;
    _fontSmall = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontSmall;
}

#pragma mark - UITableViewController
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
}

#pragma mark - Prefered Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    _fontNormal = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    _fontBigBold = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    _fontSmall = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView setNeedsLayout];
}

#pragma mark - Downloads

- (void) getDataForceDownload:(BOOL)forceDownload {
    
}
- (void) refreshData {
    [self getDataForceDownload:YES];
}

- (void) downloadEndedWithDownloadStatus:(CHDownloadStat)newDownloadStatus {
    _downloadStatus = newDownloadStatus;
    if (_downloadStatus == CHDownloadStatFailed || _downloadStatus == CHDownloadStatNoDataFound) {
    }
}

@end
