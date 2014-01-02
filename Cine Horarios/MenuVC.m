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
#import "UIViewController+ECSlidingViewController.h"

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
    
    self.navController = (UINavigationController *)self.slidingViewController.topViewController;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    [self loadMenu];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menu.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    imageView.image = [[UIImage imageNamed:self.menu[indexPath.row][@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [UIColor menuColorForRow:indexPath.row];
    label.text = self.menu[indexPath.row][@"name"];
    
    return cell;
}

#pragma mark Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = self.tableFont;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.menu[indexPath.row][@"storyboardID"];
    [self goToViewControllerWithStoryboardIdentifier:identifier indexPath:indexPath];
}

#pragma mark - MenuVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

- (void) goToViewControllerWithStoryboardIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigationController = (UINavigationController *)self.slidingViewController.topViewController;
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark Fetch Data

- (void) loadMenu {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    self.menu = [NSArray arrayWithContentsOfFile:filePath];
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}


@end
