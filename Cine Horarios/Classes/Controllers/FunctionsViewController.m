//
//  FunctionsViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 31-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsViewController.h"
#import "FunctionsCollectionCell.h"
#import "NSDate+CH.h"
#import "Theater.h"

const NSTimeInterval secondsInDay = 60*60*24;
const NSInteger daysInWeek = 7;

@interface FunctionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CollectionCellDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *functionsArray;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, weak) IBOutlet UIView *navBarExtensionView;
@property (nonatomic, weak) IBOutlet UILabel *theaterNameLabel;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@end

@implementation FunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentDate = [NSDate date];
    self.functionsArray = [NSArray new];
    NSMutableArray *tmpFunctionsArray = [[NSMutableArray alloc] initWithCapacity:daysInWeek];
    for (int i = 0; i<daysInWeek; i++) {
        [tmpFunctionsArray addObject:[NSMutableArray new]];
    }
    self.functionsArray = [NSArray arrayWithArray:tmpFunctionsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
}

#pragma mark - UICollectionView
#pragma mark UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FunctionsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.tableView.hidden = YES;
    cell.functions = self.functionsArray[indexPath.row];
    cell.delegate = self;
    cell.theaterID = self.theater.theaterID;
    cell.date = [self.currentDate datePlusDays:indexPath.row];
    [cell prepareCell];
    [cell getDataForceDownload:NO];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return daysInWeek;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

-(void)tableCellDidSelect:(UITableViewCell *)cell {
    
}

@end
