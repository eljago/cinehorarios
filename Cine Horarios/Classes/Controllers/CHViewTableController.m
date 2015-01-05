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
#import "UIScrollView+EmptyDataSet.h"
#import "UIFont+CH.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIFont+CH.h"

@interface CHViewTableController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    @protected
    UIFont *fontBody;
    UIFont *fontHeadline;
    UIFont *fontFootnote;
    UITableView *tableView;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, assign, readwrite) CHDownloadStat downloadStatus;
@property (nonatomic, assign, readwrite) BOOL shouldShowEmptyDataSet;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@end

@implementation CHViewTableController
@synthesize tableView = _tableView;
@synthesize fontNormal = _fontNormal;
@synthesize fontBigBold = _fontBigBold;
@synthesize fontSmall = _fontSmall;
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    //    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor blackColor];
    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Low Memory warning");
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) addMenuButton {
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
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
        _shouldShowEmptyDataSet = YES;
    }
}

#pragma mark - Empty Data Set DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                 };
    
    NSString *text;
    switch (self.downloadStatus) {
        case CHDownloadStatFailed:
            text = @"Descarga Fallida";
            break;
            
        case CHDownloadStatNoDataFound:
            text = @"Datos aún no disponibles";
            break;
            
        default:
            text = @"Datos aún no disponibles";
            break;
    }
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: self.fontBigBold,
                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    NSString *text = @"";
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName: self.fontNormal,
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:@"Reintentar" attributes:attributes];
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
    [self refreshData];
}

@end
