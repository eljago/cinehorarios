//
//  FunctionsContainerVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 10-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsContainerVC.h"
#import "UIColor+CH.h"
#import "FileHandler.h"
#import "GAI+CH.h"
#import "FunctionsPageVC.h"
#import "Theater.h"
#import "FuncionesVC.h"
#import "FavoritesManager.h"

@interface FunctionsContainerVC ()

@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, strong) UIBarButtonItem *menuButtonItem;

@property (nonatomic, weak) IBOutlet UIView *functionsContainerVC;
@property (nonatomic, weak) IBOutlet UIView *navBarExtensionView;
@property (nonatomic, weak) IBOutlet UILabel *theaterNameLabel;

@property (nonatomic, strong) FunctionsPageVC *pageViewController;

@property (nonatomic, assign) BOOL favorite;

@end

@implementation FunctionsContainerVC {
    BOOL viewAppeared;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.theaterNameLabel.text = self.theater.name;
    
    [GAI trackPage:@"FUNCIONES"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Complejos Visitados" label:self.theater.name];
    
    [self createButtonItems];
    
    self.pageControl.tintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.navBarExtensionView.backgroundColor = [UIColor navColor];
    self.view.backgroundColor = [UIColor tableViewColor];
    
    [self setupFavorites];
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

#pragma mark Create View

-(void) createButtonItems {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(0, 0, 40, 40);
    [favoriteButton addTarget:self action:@selector(setFavoriteTheater:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"FavoriteHeart"];
    
    self.favoriteButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(setFavoriteTheater:)];
    self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    self.favoriteButtonItem.enabled = NO;
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItems = @[menuButtonItem, self.favoriteButtonItem];
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
    FuncionesVC *funcionesVC = [self.pageViewController getCurrentFuncionesVC];
    Theater *theater = funcionesVC.theater;
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

#pragma mark - Prepare for Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.pageViewController = (FunctionsPageVC *)[segue destinationViewController];
    self.pageViewController.functionsContainerVC = self;
}

#pragma mark - Supported Interface Orientation

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
