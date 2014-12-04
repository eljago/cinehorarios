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

@interface FunctionsContainerVC ()

@property (nonatomic, strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic, strong) UIBarButtonItem *menuButtonItem;

@property (nonatomic, weak) IBOutlet UIView *functionsContainerVC;
@property (nonatomic, weak) IBOutlet UIView *navBarExtensionView;
@property (nonatomic, weak) IBOutlet UILabel *theaterNameLabel;

@property (nonatomic, assign) BOOL favorite;

@end

@implementation FunctionsContainerVC


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.theaterNameLabel.text = self.theaterName;
    
    [GAI trackPage:@"FUNCIONES"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Complejos Visitados" label:self.theaterName];
    
    [self createButtonItems];
    [self setupFavorites];
    
    self.pageControl.tintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.navBarExtensionView.backgroundColor = [UIColor navColor];
    self.view.backgroundColor = [UIColor tableViewColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupFavorites];
}

#pragma mark Create View

-(void) createButtonItems {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(0, 0, 40, 40);
    [favoriteButton addTarget:self action:@selector(setFavoriteTheater:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"FavoriteHeart"];
    
    self.favoriteButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(setFavoriteTheater:)];
    self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.navigationItem.rightBarButtonItems = @[menuButtonItem, self.favoriteButtonItem];
}
- (void) setupFavorites{
    
    NSDictionary *dict = [FileHandler getDictionaryInProjectNamed:@"icloud"];
    NSDictionary *favorites = [dict valueForKey:@"Favorites"];
    NSString *theaterName = [favorites valueForKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.theaterID]];
    if (theaterName) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
        self.favorite = YES;
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
        self.favorite = NO;
    }
}

- (IBAction) setFavoriteTheater:(id)sender{
    self.favorite = !self.favorite;
    if (self.favorite) {
        self.favoriteButtonItem.tintColor = [UIColor whiteColor];
    }
    else{
        self.favoriteButtonItem.tintColor = [UIColor navUnselectedColor];
    }
    // Notify the previouse view to save the changes locally
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Toggle Favorite"
                                                        object:self
                                                      userInfo:@{@"TheaterName": self.theaterName,
                                                                 @"TheaterID": [NSNumber numberWithInteger:self.theaterID]}];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FunctionsPageVC *functionsPageVC = (FunctionsPageVC *)[segue destinationViewController];
    functionsPageVC.functionsContainerVC = self;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
