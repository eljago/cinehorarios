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

@interface VideosVC ()

@property (nonatomic, strong) VideoGroup *videoGroup;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UIFont *tableFont;

@end

@implementation VideosVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

#pragma mark Fetch Data

- (void) getVideosForceDownload:(BOOL)forceDownload {
    if (forceDownload) {
        [self downloadCinema];
    }
    else {
        self.videoGroup = [VideoGroup loadVideoGroup];
        if (self.videoGroup && self.videoGroup.videos.count > 0) {
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

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    Video *video = self.videoGroup.videos[sender.tag];
    BasicMovie *basicMovie = video.movie;
    if ([[segue identifier] isEqualToString:@"VideosVCToMovieVC"]) {
        MovieVC *movieVC = segue.destinationViewController;
        movieVC.movieID = basicMovie.movieID;
        movieVC.movieName = basicMovie.name;
        movieVC.portraitImageURL = basicMovie.portraitImageURL;
    }
    else if ([[segue identifier] isEqualToString:@"VideosVCToVideoVC"]) {
        VideoVC *videoVC = segue.destinationViewController;
        videoVC.videos = @[video];
    }
}

@end
