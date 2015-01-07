//
//  FunctionsVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsVC.h"
#import "FunctionDayVC.h"
#import "Theater.h"
#import "FunctionDayVC.h"
#import "GAI+CH.h"
#import "NSDate+CH.h"
#import "UIColor+CH.h"
#import "FavoritesManager.h"

const NSInteger numberOfVCs = 7;

@interface FunctionsVC ()

@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, assign) BOOL favorite;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UILabel *TopLabel;

@end

@implementation FunctionsVC {
    BOOL viewAppeared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GAI trackPage:@"FUNCIONES"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Complejos Visitados" label:self.theater.name];
    
    [self createButtonItems];
    
    self.TopView.backgroundColor = [UIColor navColor];
    self.TopLabel.text = self.theater.name;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:numberOfVCs];
    for (int i=0; i<numberOfVCs; i++) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:60*60*24*(i+1)];
        FunctionDayVC *functionDayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FunctionDayVC"];
        functionDayVC.theaterName = self.theater.name;
        functionDayVC.theaterID = self.theater.theaterID;
        functionDayVC.title = [[date getShortDateString] capitalizedString];
        functionDayVC.date = date;
        [viewControllers addObject:functionDayVC];
    }
    self.viewControllers = viewControllers;
    
    __weak __typeof(self)weakSelf = self;
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FunctionDayVC *functionDayVC = strongSelf.viewControllers[cuurentPage];
        [functionDayVC getDataForceDownload:NO];
    };
    
    [self reloadData];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.favoriteButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!viewAppeared) [self setupFavorites];
    viewAppeared = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Supported Interface Orientation

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Favorites

-(void) createButtonItems {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(0, 0, 40, 40);
    [favoriteButton addTarget:self action:@selector(setFavoriteTheater:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"FavoriteHeart"];
    
    self.favoriteButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(setFavoriteTheater:)];
    self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    self.favoriteButtonItem.enabled = NO;
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.favoriteButtonItem;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupFavorites{
    if ([[FavoritesManager sharedManager] theaterWithTheaterID:self.theater.theaterID]) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
        self.favorite = YES;
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
        self.favorite = NO;
    }
    self.favoriteButtonItem.enabled = YES;
}

- (IBAction) setFavoriteTheater:(id)sender{
    FunctionDayVC *functionDayVC = self.viewControllers[self.getCurrentPageIndex];
    Theater *theater = functionDayVC.theater;
    if (theater) {
        self.favoriteButtonItem.enabled = NO;
        [[FavoritesManager sharedManager] toggleTheater:theater withCompletionBlock:^{
            self.favorite = !self.favorite;
            if (self.favorite) {
                self.favoriteButtonItem.tintColor = [UIColor whiteColor];
            }
            else{
                self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
            }
            self.favoriteButtonItem.enabled = YES;
        }];
    }
}

@end
