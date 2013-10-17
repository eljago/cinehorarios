//
//  MenuVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MenuVC.h"
#import "BasicImageItem.h"
#import "ECSlidingViewController.h"
#import "GlobalNavigationController.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MenuCell.h"

@interface MenuVC ()
@property (nonatomic, strong) NSArray *menu;
@end

@implementation MenuVC {
    UIFont *tableFont;
    NSInteger selectedRow;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [self loadMenu];
    self.tableView.tableHeaderView = [self getTableHeaderView];
    selectedRow = 0;
    
    [self.slidingViewController setAnchorRightRevealAmount:220.f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void) loadMenu {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableMenu = [NSMutableArray array];
    for (NSDictionary *dict in menuLocal) {
        [mutableMenu addObject:@{@"name": dict[@"name"], @"storyboardID": dict[@"storyboardID"], @"image": dict[@"image"]}];
    }
    self.menu = [NSArray arrayWithArray:mutableMenu];
}
- (UIView *) getTableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 100)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(79, 25, 62, 62)];
    imgView.image = [UIImage imageNamed:@"LogoCineHorarios"];
    imgView.tintColor = [UIColor whiteColor];
    imgView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [view addSubview:imgView];
    return view;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = tableFont;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.menu[indexPath.row][@"storyboardID"];
    GlobalNavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = navVC;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    selectedRow = indexPath.row;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}

@end
