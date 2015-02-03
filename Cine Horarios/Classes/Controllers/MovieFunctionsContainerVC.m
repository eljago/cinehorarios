//
//  MovieFunctionsContainerVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieFunctionsContainerVC.h"
#import "GAI+CH.h"
#import "NSDate+CH.h"
#import "MovieFunctionsVC.h"
#import "UIColor+CH.h"
#import "FavoritesManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"

static const NSInteger numberOfVCs = 7;

@interface MovieFunctionsContainerVC ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation MovieFunctionsContainerVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [GAI trackPage:@"PELICULA FUNCIONES"];
    
    self.view.backgroundColor = [UIColor tableViewColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = numberOfVCs;
    self.pageControl.tintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.topView.backgroundColor = [UIColor navColor];
    self.title = self.movieName;
    
    if ([FavoritesManager getShouldDownloadFavorites]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
        FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
        [favoritesManager downloadFavoriteTheatersWithBlock:^(NSError *error) {
            if (!error) {
                [self gotDataSoReload];
            }
            else {
                NSLog(@"%@",error.localizedDescription);
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else {
        [self gotDataSoReload];
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) gotDataSoReload {
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:numberOfVCs];
    for (int i=0; i<numberOfVCs; i++) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:60*60*24*i];
        MovieFunctionsVC *movieFunctionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieFunctionsVC"];
        movieFunctionsVC.movieID = self.movieID;
        movieFunctionsVC.movieName = self.movieName;
        movieFunctionsVC.date = date;
        movieFunctionsVC.title = [[date getShortDateString] capitalizedString];
        [viewControllers addObject:movieFunctionsVC];
    }
    self.viewControllers = viewControllers;
    
    __weak __typeof(self)weakSelf = self;
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.pageControl.currentPage = cuurentPage;
        MovieFunctionsVC *movieFunctionsVC = strongSelf.viewControllers[cuurentPage];
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:60*60*24*cuurentPage];
        strongSelf.title = [[date getShortDateString] capitalizedString];
        [movieFunctionsVC getDataForceDownload:NO];
    };
    
    [self reloadData];
}

@end
