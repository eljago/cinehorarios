//
//  Videos.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideosVC.h"
#import "VideoGroup.h"
#import "Video.h"
#import "UIFont+CH.h"
#import "MBProgressHUD.h"
#import "UIViewController+DoAlertView.h"
#import "VideoCell.h"
#import "VideoCell+Video.h"
#import "MovieVC.h"
#import "VideoVC.h"
#import "BasicMovie.h"

#import "MHGalleryOverViewController.h"

#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface VideosVC ()

@property (nonatomic, strong) VideoGroup *videoGroup;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UIFont *tableFont;
@property( nonatomic,strong) NSArray *galleryDataSource;

@end

@implementation VideosVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"VIDEOS" forKey:kGAIScreenName] build]];
    
    self.title = @"Últimos Videos";
    
    self.currentPage = 1;
    
    [self getVideosForceDownload:YES];
}


#pragma mark - TheatersVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

- (void) setUpsGalleryDataSource {
    
    NSMutableArray *galleryDataSourceArray = [NSMutableArray array];
    for (Video *video in self.videoGroup.videos) {
        NSString *urlString = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",video.code];
        MHGalleryItem *youtube = [[MHGalleryItem alloc]initWithURL:urlString
                                                       galleryType:MHGalleryTypeVideo];
        [galleryDataSourceArray addObject:youtube];
        
    }
    self.galleryDataSource = [NSArray arrayWithArray:galleryDataSourceArray];
}

#pragma mark Fetch Data

- (void) getVideosForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadCinema];
    }
    else {
        self.videoGroup = [VideoGroup loadVideoGroup];
        if (self.videoGroup && self.videoGroup.videos.count > 0) {
            
            [self setUpsGalleryDataSource];
            
            [self.tableView reloadData];
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            [self downloadCinema];
        }
    }
}

-(void) downloadCinema {
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VideoGroup getVideosWithBlock:^(VideoGroup *videoGroup, NSError *error) {
        if (!error) {
            self.videoGroup = videoGroup;
            [self setUpsGalleryDataSource];
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getVideosForceDownload:YES];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } page:self.currentPage];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getVideosForceDownload:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoGroup.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    Video *video = self.videoGroup.videos[indexPath.row];
    [cell configureForVideo:video];
    cell.showCoverButton.tag = indexPath.row;
    cell.videoCoverButton.tag = indexPath.row;
    
    return cell;
}

- (IBAction)goVideoGallery:(UIButton *)sender {
    
    VideoCell *cell = (VideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [MHGallerySharedManager sharedManager].ivForPresentingAndDismissingMHGallery = cell.videoCoverImageView;
    
    [self presentMHGalleryWithItems:self.galleryDataSource forIndex:sender.tag finishCallback:^(UINavigationController *galleryNavMH, NSInteger pageIndex, UIImage *image) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MHGallerySharedManager sharedManager].ivForPresentingAndDismissingMHGallery = cell.videoCoverImageView;
            
            [galleryNavMH dismissViewControllerAnimated:YES completion:nil];
        });
        
    } customAnimationFromImage:NO];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    Video *video = self.videoGroup.videos[sender.tag];
    BasicMovie *basicMovie = video.movie;
    MovieVC *movieVC = segue.destinationViewController;
    movieVC.movieID = basicMovie.movieID;
    movieVC.movieName = basicMovie.name;
    movieVC.portraitImageURL = basicMovie.portraitImageURL;
}

@end
