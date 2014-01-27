//
//  MenuVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MenuVC.h"
#import "GlobalNavigationController.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MenuCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FileHandler.h"

@interface MenuVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIFont *tableFont;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation MenuVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    if (self.startingVCID) {
        [self selectRowWithStoryboardID:self.startingVCID];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self.tableView indexPathForSelectedRow]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menu.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu[section][@"items"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *itemDict = self.menu[indexPath.section][@"items"][indexPath.row];
    
    cell.imgView.image = [[UIImage imageNamed:itemDict[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imgView.tintColor = [UIColor menuColorForRow:indexPath];
    cell.txtLabel.text = itemDict[@"name"];
    cell.txtLabel.highlightedTextColor = [UIColor menuColorForRow:indexPath];
    
    return cell;
}

#pragma mark Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 22.)];
    backgroundView.backgroundColor = [UIColor clearColor];
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width-10, 22.)];
    labelHeader.font = _tableFont;
    labelHeader.textColor = [UIColor lighterGrayColor];
    labelHeader.text = self.menu[section][@"name"];
    [backgroundView addSubview:labelHeader];
    return backgroundView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ((MenuCell *)cell).txtLabel.font = self.tableFont;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.menu[indexPath.section][@"items"][indexPath.row][@"storyboardID"];
    [self goToViewControllerWithStoryboardIdentifier:identifier indexPath:indexPath];
}

#pragma mark - MenuVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}
- (NSArray *) menu {
    if(_menu) return _menu;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    _menu = [NSArray arrayWithContentsOfFile:filePath];
    
    return _menu;
}
- (UINavigationController *) navController {
    if(_navController) return _navController;
    
    _navController = (UINavigationController *)self.slidingViewController.topViewController;
    
    return _navController;
}

#pragma mark Select Row
-(void)selectRowWithStoryboardID:(NSString *)identifier {
    
    [FileHandler getMenuDictsAndSelectedIndex:^(NSArray *menuDicts, NSInteger selectedIndex) {
        NSInteger section = 0;
        NSInteger selectedIndx = selectedIndex;
        if (selectedIndex <= 2) {
            section = 0;
        }
        else if (selectedIndex <= 4) {
            section = 1;
            if (selectedIndex == 3) {
                selectedIndx = 0;
            }
            else {
                selectedIndx = 1;
            }
        }
        else {
            section = 2;
            selectedIndx = 0;
        }
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndx inSection:section] animated:NO scrollPosition:UITableViewRowAnimationTop];
    } withStoryboardID:identifier];
    
}

#pragma mark Switch Top VC

- (void) goToViewControllerWithStoryboardIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigationController = (UINavigationController *)self.slidingViewController.topViewController;
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    GlobalNavigationController *nvc = (GlobalNavigationController *)navigationController;
    nvc.transitionPanGesture.enabled = YES;
    nvc.navigationBar.barTintColor = [UIColor navColor];
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}


@end
