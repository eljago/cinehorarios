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
}

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menu.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:44];
    imgView.image = [UIImage imageNamed:@"MenuCellBG"];
    cell.imageView.image = [UIImage imageNamed:self.menu[indexPath.section][indexPath.row][@"image"]];
    cell.textLabel.text = self.menu[indexPath.section][indexPath.row][@"name"];
    
    return cell;
}

#pragma mark Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = self.tableFont;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.menu[indexPath.section][indexPath.row][@"storyboardID"];
    [self goToViewControllerWithStoryboardIdentifier:identifier];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text;
    if (section == 0) {
        text = @"Cines";
    }
    else if (section == 1) {
        text = @"Películas";
    }
    else {
        text = @"";
    }
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 70)];
    view.image = [UIImage imageNamed:@"MenuHeaderBG1"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20.f, 280.f, 50)];
    label.textColor = [UIColor whiteColor];
    label.tag = 40;
    label.font = self.tableFont;
    label.text = text;
    [view addSubview: label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.f;
}

#pragma mark - MenuVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

- (void) goToViewControllerWithStoryboardIdentifier:(NSString *)identifier {
    UINavigationController *navigationController = (UINavigationController *)self.slidingViewController.topViewController;
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - IBActions

- (IBAction) clickSettingsButton:(id)sender {
    
    NSString *identifier = @"SettingsVC";
    [self goToViewControllerWithStoryboardIdentifier:identifier];
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
