//
//  FunctionsPageVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 07-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsPageVC.h"
#import "FuncionesVC.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "NSDate+CH.h"
#import "FunctionsContainerVC.h"

NSInteger const kNumberOfViewControllers = 7;

@interface FunctionsPageVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) NSMutableArray *failedDownloads;

@end

@implementation FunctionsPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNumber numberWithBool:NO];
    self.failedDownloads = [NSMutableArray arrayWithCapacity:kNumberOfViewControllers];
    for (int i = 0; i<kNumberOfViewControllers; i++) {
        [self.failedDownloads insertObject:[NSNumber numberWithInteger:CHDownloadStatusNotDownloaded] atIndex:i];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.showtimesFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    self.delegate = self;
    self.dataSource = self;
    
    FuncionesVC *funcionesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FuncionesVC"];
    funcionesVC.functionsPageVC = self;
    funcionesVC.pageIndex = 0;
    [self setViewControllers:@[funcionesVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.currentDate = [NSDate date];
    funcionesVC.dateString = [self.currentDate getShortDateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CHDownloadStatus) getDownloadStatusForIndex:(NSInteger)index {
    return [[self.failedDownloads objectAtIndex:index] integerValue];
}
- (void) setDownloadStatus:(CHDownloadStatus)downloadStatus atIndex:(NSInteger)index {
    [self.failedDownloads insertObject:[NSNumber numberWithInteger:downloadStatus] atIndex:index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.headFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.bodyFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.showtimesFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    FuncionesVC *funcionesVC = (FuncionesVC *)[self.viewControllers objectAtIndex:self.currentIndex];
    [funcionesVC.tableView reloadData];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FuncionesVC*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FuncionesVC*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == kNumberOfViewControllers) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Page View Controller Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    FuncionesVC *funcionesVC = [pendingViewControllers firstObject];
    self.nextIndex = funcionesVC.pageIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if(completed){
        self.currentIndex = self.nextIndex;
        self.functionsContainerVC.pageControl.currentPage = self.currentIndex;
    }
    
    self.nextIndex = 0;
}

- (FuncionesVC *)viewControllerAtIndex:(NSUInteger)index
{
    if ((kNumberOfViewControllers == 0) || (index >= kNumberOfViewControllers)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    FuncionesVC *funcionesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FuncionesVC"];
    funcionesVC.functionsPageVC = self;
    funcionesVC.pageIndex = index;
    funcionesVC.dateString = [[self.currentDate dateByAddingTimeInterval:60*60*24*index] getShortDateString];
    
    return funcionesVC;
}

- (FuncionesVC *) getCurrentFuncionesVC {
    return (FuncionesVC *)[self.viewControllers objectAtIndex:self.currentIndex];
}


@end
