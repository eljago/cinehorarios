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

#import "GAI+CH.h"

const int kLoadingCellTag = 1234;

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
    
    [GAI trackPage:@"VIDEOS"];
    
    self.title = @"Últimos Videos";
    
    self.currentPage = 1;
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getVideosLocally];
}

#pragma mark - TheatersVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

#pragma mark Fetch Data

- (void) getVideosLocally {
    self.videoGroup = [VideoGroup loadVideoGroup];
    if (self.videoGroup && self.videoGroup.videos.count > 0) {
        
        [self.tableView reloadData];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }
    else {
        [self downloadVideosForPage:1];
    }
}

-(void) downloadVideosForPage:(NSUInteger)page {
    if (page == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [VideoGroup getVideosWithBlock:^(VideoGroup *videoGroup, NSError *error) {
        if (!error) {
            if (self.videoGroup && page > 1) {
                [self.videoGroup.videos addObjectsFromArray:videoGroup.videos];
            }
            else {
                self.videoGroup = videoGroup;
            }
            [self.tableView reloadData];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self downloadVideosForPage:page];
            }];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } page:page];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    self.currentPage = 1;
    [self downloadVideosForPage:self.currentPage];
}

#pragma mark - UITableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.videoGroup.videos.count) {
        return 140.;
    }
    else {
        return 44.;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.videoGroup.videos.count + 1;
}

- (VideoCell *) videoCellForIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    VideoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    Video *video = self.videoGroup.videos[indexPath.row];
    [cell configureForVideo:video];
    cell.showCoverButton.tag = indexPath.row;
    cell.videoCoverButton.tag = indexPath.row;
    
    return cell;
}

- (UITableViewCell *) loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = cell.center;
    [cell addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.videoGroup.videos.count) {
        return [self videoCellForIndexPath:indexPath];
    }
    else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        self.currentPage++;
        [self downloadVideosForPage:self.currentPage];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    if ([[segue identifier] isEqualToString:@"VideosVCToMovieVC"]) {
        Video *video = self.videoGroup.videos[sender.tag];
        BasicMovie *basicMovie = video.movie;
        MovieVC *movieVC = segue.destinationViewController;
        movieVC.movieID = basicMovie.movieID;
        movieVC.movieName = basicMovie.name;
        movieVC.portraitImageURL = basicMovie.portraitImageURL;
        movieVC.coverImageURL = basicMovie.imageURL;
    }
    else if ([[segue identifier] isEqualToString:@"VideosVCToVideoVC"]) {
        VideoVC *videoVC = segue.destinationViewController;
        videoVC.videos = @[self.videoGroup.videos[sender.tag]];
    }
}

@end
