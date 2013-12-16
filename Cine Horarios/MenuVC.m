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
#import "ECSlidingViewController.h"

@interface MenuVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MenuVC {
    UIFont *tableFont;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:220.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
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

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menu.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.imageView.image = [UIImage imageNamed:self.menu[indexPath.row][@"image"]];
    cell.textLabel.text = self.menu[indexPath.row][@"name"];
    
    return cell;
}

#pragma mark Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = tableFont;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.menu[indexPath.row][@"storyboardID"];
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];

    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = navigationController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


#pragma mark - MenuVC
#pragma mark Fetch Data

- (void) loadMenu {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableMenu = [NSMutableArray array];
    for (NSDictionary *dict in menuLocal) {
        [mutableMenu addObject:@{@"name": dict[@"name"], @"storyboardID": dict[@"storyboardID"], @"image": dict[@"image"]}];
    }
    self.menu = [NSArray arrayWithArray:mutableMenu];
}

#pragma mark Create View
- (UIView *) getTableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 100)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(79, 25, 62, 62)];
    imgView.image = [UIImage imageNamed:@"LogoCineHorarios"];
    imgView.tintColor = [UIColor whiteColor];
    imgView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [view addSubview:imgView];
    return view;
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}


@end
