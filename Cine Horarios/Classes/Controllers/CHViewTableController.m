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
#import "UIViewController+ScrollingNavbar.h"

@interface CHViewTableController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    @protected
    UIFont *fontBody;
    UIFont *fontHeadline;
    UIFont *fontFootnote;
    UITableView *tableView;
}

@property (nonatomic, assign, readwrite) CHDownloadStat downloadStatus;
@property (nonatomic, assign, readwrite) BOOL shouldShowEmptyDataSet;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@end

@implementation CHViewTableController
@synthesize tableView = _tableView;
@synthesize fontBody = _fontBody;
@synthesize fontHeadline = _fontHeadline;
@synthesize fontFootnote = _fontFootnote;

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
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.tableView usingTopConstraint:self.topLayoutConstraint withDelay:65];
    [self setShouldScrollWhenContentFits:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Low Memory warning");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showNavBarAnimated:NO];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Attributes
- (UIFont *) fontBody {
    if(_fontBody) return _fontBody;
    _fontBody = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return _fontBody;
}
- (UIFont *) fontHeadline {
    if(_fontHeadline) return _fontHeadline;
    _fontHeadline = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return _fontHeadline;
}
- (UIFont *) fontFootnote {
    if(_fontFootnote) return _fontFootnote;
    _fontFootnote = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return _fontFootnote;
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
    _fontBody = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _fontHeadline = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _fontFootnote = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.tableView setNeedsLayout];
}

#pragma mark - Downloads

- (void) refreshData{};

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
    
    NSDictionary *attributes = @{NSFontAttributeName: self.fontHeadline,
                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    NSString *text = @"";
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName: self.fontBody,
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
