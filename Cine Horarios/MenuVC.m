//
//  MenuVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MenuVC.h"
#import "BasicImageItem.h"
#import "GlobalNavigationController.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MenuCell.h"
#import "UIViewController+RESideMenu.h"

@interface MenuVC ()
@property (nonatomic, strong) NSArray *menu;
@end

@implementation MenuVC {
    UIFont *tableFont;
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
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    
    NSString *identifier = self.menu[indexPath.row][@"storyboardID"];
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}


@end
