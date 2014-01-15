//
//  MovieVCViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieVC.h"
#import "Movie.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MyMultilineLabel.h"
#import "MovieImagesVC.h"
#import "Actor.h"
#import "CastVC.h"
#import "WebVC.h"
#import "VideoItem.h"
#import "UIImageView+CH.h"
#import "MWPhoto.h"
#import "MBProgressHUD.h"
#import "MovieCinemasVC.h"
#import "ComingSoonVC.h"
#import "VideoVC.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "UIView+CH.h"
#import "GlobalNavigationController.h"

@interface MovieVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) Movie *movie;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewActors;

@property (nonatomic, weak) IBOutlet UIImageView *portraitImageView;
@property (nonatomic, strong) MyMultilineLabel *labelName;
@property (nonatomic, strong) MyMultilineLabel *labelNameOriginal;
@property (nonatomic, strong) MyMultilineLabel *labelDurationGenres;
@property (nonatomic, strong) UIView *viewOverPortrait;
@property (nonatomic, weak) IBOutlet UILabel *labelDirector;

@property (nonatomic, weak) IBOutlet UIImageView *coverImageView;
@property (nonatomic, weak) IBOutlet UITextView *textViewSynopsis;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreMetacritic;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreImdb;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreRottenTomatoes;
@property (nonatomic, weak) IBOutlet UILabel *labelBuscarHorarios;
@property (nonatomic, weak) IBOutlet UILabel *labelVideos;

@end

@implementation MovieVC {
    UIFont *smallerFont;
    UIFont *normalFont;
    UIFont *bigBoldFont;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"INFO PELICULA" forKey:kGAIScreenName] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Preferencias Usuario"
                                                          action:@"Peliculas Visitadas"
                                                           label:self.movieName
                                                           value:nil] build]];
    
    // TopView it's the view over the tableview while it's downloading the data for the first time
    UIView *topView = [[UIView alloc] initWithFrame:self.view.bounds];
    topView.backgroundColor = [UIColor tableViewColor];
    topView.tag = 999;
    [self.view addSubview:topView];
    
    [self setupViews];
    
    // Defining and setting fonts
    [self setFontsWithPreferedContentSizeCategory: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getMovieForceRemote:NO];
}

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ((!self.movie.urlRottenTomatoes || [self.movie.urlRottenTomatoes isEqualToString:@""]) &&
        (!self.movie.urlImdb || [self.movie.urlImdb isEqualToString:@""]) &&
        (!self.movie.urlMetacritic || [self.movie.urlMetacritic isEqualToString:@""])) {
        return 4;
    }
    else {
        return 5;
    }
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        if (indexPath.row == 0){
            if (!self.movie.urlMetacritic || [self.movie.urlMetacritic isEqualToString:@""]) {
                return 0.;
            }
        }
        else if(indexPath.row == 1){
            if (!self.movie.urlImdb || [self.movie.urlImdb isEqualToString:@""]) {
                return 0.;
            }
        }
        else if (indexPath.row == 2){
            if (!self.movie.urlRottenTomatoes || [self.movie.urlRottenTomatoes isEqualToString:@""]) {
                return 0.;
            }
        }
    }
    else if (indexPath.section == 3) {
        if (self.movie.images.count == 0) {
            return 0.;
        }
    }
    else if (indexPath.section == 2) {
        if (self.movie.actors.count == 0) {
            return 0.;
        }
    }
    else if (indexPath.section == 1) {
        if (self.movie.directors.count == 0) {
            return 0.;
        }
        else {
            CGSize size = CGSizeMake(277.f, 1000.f);
            
            NSMutableArray *directorsNames = [[NSMutableArray alloc] init];
            for (Actor *actor in self.movie.directors) {
                [directorsNames addObject:actor.name];
            }
            
            CGRect nameLabelRect = [[directorsNames componentsJoinedByString:@", "] boundingRectWithSize: size
                                                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes: [NSDictionary dictionaryWithObject:normalFont forKey:NSFontAttributeName]
                                                                                                 context: nil];
            
            CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
            
            return totalHeight;
        }
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGFloat height;
            if (self.movie.synopsis) {
                NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
                NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.textViewSynopsis.frame.size.width, 1000)];
                UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.coverImageView.frame.size.width+10, self.coverImageView.frame.size.height+10)];
                container.exclusionPaths = @[exclusionPath];
                
                NSDictionary* attrs = @{NSFontAttributeName: normalFont};
                
                NSTextStorage *txtStorage = [[NSTextStorage alloc] initWithString:self.movie.synopsis attributes:attrs];
                [txtStorage addLayoutManager:layoutManager];
                [layoutManager addTextContainer:container];
                
                height = self.textViewSynopsis.frame.origin.y + [layoutManager boundingRectForGlyphRange:[layoutManager glyphRangeForTextContainer:container] inTextContainer:container].size.height+15.;
            }
            else {
                height = 155.;
            }
            return MAX(height, 155.);
        }
        else if (indexPath.row == 3) {
            if ([self.navigationController.viewControllers[0] isMemberOfClass:[ComingSoonVC class]]) {
                return 0.;
            }
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *text;
    switch (section) {
        case 0:
            text = @"";
            break;
        case 1:
            if (self.movie.directors.count > 1) {
                text = @"Directores";
            }
            else if(self.movie.directors.count == 1){
                text = @"Director";
            }
            else {
                return [UIView new];
            }
            break;
        case 2:
            if (self.movie.actors.count == 0) {
                return [UIView new];
            }
            text = @"Reparto";
            break;
        case 3:
            if (self.movie.images.count == 0) {
                return [UIView new];
            }
            text = @"Imágenes";
            break;
        case 4:
            text = @"Calificaciones";
            break;
            
        default:
            text = @"";
            break;
    }
    NSInteger height = [UIView heightForHeaderViewWithText:text font:normalFont];
    return [UIView headerViewForText:text font:bigBoldFont height:height];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 4 && indexPath.row == 1)) {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark - MovieVC

#pragma mark Row & Height Calculators

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1 && self.movie.directors.count == 0) {
        return 0.01f;
    }
    else if (section == 2 && self.movie.actors.count == 0) {
        return 0.01f;
    }
    else if (section == 3 && self.movie.images.count == 0) {
        return 0.01f;
    }
    else {
        return [UIView heightForHeaderViewWithText:@"Javier" font:normalFont];
    }
}

#pragma mark Fetch Data

- (void) getMovieForceRemote:(BOOL) forceRemote {
    if (forceRemote) {
        [self downloadMovie];
    }
    else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.movie = [Movie getLocalMovieWithMovieID:self.movieID];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (self.movie) {
                    [self setupTableViews];
                }
                else {
                    [self downloadMovie];
                }
            });
        });
    }
}

- (void) downloadMovie {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Movie getMovieWithBlock:^(Movie *movie, NSError *error) {
        if (!error) {
            self.movie = movie;
            [self setupTableViews];
        }
        else {
            [self alertRetryWithCompleteBlock:^{
                [self getMovieForceRemote:YES];
            }];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } movieID:self.movieID];
}
-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getMovieForceRemote:YES];
}


#pragma mark - Set TableView values

- (void) setupTableViews {
    
    // PORTRAIT IMAGE
    if (self.portraitImageURL) {
        [self.portraitImageView setImageWithStringURL:self.portraitImageURL movieImageType:MovieImageTypePortrait placeholderImage:nil];
    }
    
    // NAME AND YEAR
    if (self.movie.name) {
        self.labelName.text = self.movie.name;
    }
    if (self.movie.year){
        self.labelName.text = [self.labelName.text stringByAppendingFormat:@" (%@)",self.movie.year];
    }
    if (self.movie.nameOriginal){
        self.labelNameOriginal.text = [NSString stringWithFormat:@"\"%@\"",self.movie.nameOriginal];
    }
    if (self.movie.duration) {
        self.labelDurationGenres.text = self.movie.duration;
    }
    if (self.movie.duration && self.movie.genres) {
        self.labelDurationGenres.text = [self.labelDurationGenres.text stringByAppendingString:@" - "];
    }
    if (self.movie.genres) {
        self.labelDurationGenres.text = [self.labelDurationGenres.text stringByAppendingFormat:@"%@",self.movie.genres];
    }
    
    if (self.movie.imageUrl) {
        [self.coverImageView setImageWithStringURL:self.movie.imageUrl movieImageType:MovieImageTypeCover];
    }
    
    // SYNOPSIS
    if (self.movie.synopsis) {
        self.textViewSynopsis.hidden = NO;
        NSDictionary* attrs = @{NSFontAttributeName: normalFont};
        
        NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:self.movie.synopsis
                                                                         attributes:attrs];
        
        self.textViewSynopsis.attributedText = attrString;
        self.textViewSynopsis.contentOffset = CGPointMake(0, -8);
    }
    else {
        self.textViewSynopsis.hidden = YES;
    }
    
    if (self.movie.directors) {
        Actor *actor = [self.movie.directors firstObject];
        self.labelDirector.text = actor.name;
        if (self.movie.directors.count > 1) {
            for (int i=1; i<self.movie.directors.count; i++) {
                Actor *actor = self.movie.directors[i];
                self.labelDirector.text = [self.labelDirector.text stringByAppendingFormat:@", %@",actor.name];
            }
        }
    }
    if (self.movie.actors.count == 0) {
        self.collectionViewActors.hidden = YES;
    }
    else {
        self.collectionViewActors.hidden = NO;
        [self.collectionViewActors reloadData];
    }
    if (self.movie.images.count == 0) {
        self.collectionView.hidden = YES;
    }
    else {
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }
    
    if (self.movie.scoreImdb) {
        self.labelScoreImdb.text = self.movie.scoreImdb;
    }
    else {
        self.labelScoreImdb.text = @"?";
    }
    if (self.movie.scoreMetacritic) {
        self.labelScoreMetacritic.text = self.movie.scoreMetacritic;
    }
    else {
        self.labelScoreMetacritic.text = @"?";
    }
    if (self.movie.scoreRottenTomatoes) {
        self.labelScoreRottenTomatoes.text = self.movie.scoreRottenTomatoes;
    }
    else {
        self.labelScoreRottenTomatoes.text = @"?";
    }
    
    
    UIView *frontView = [self.view viewWithTag:999];
    [UIView animateWithDuration:0.3 animations:^{
        frontView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [frontView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }];
    [self.tableView reloadData];
}

#pragma mark - Notification Observer method

-(void) setFontsWithPreferedContentSizeCategory:(NSString *)preferredContentSizeCategory {
    smallerFont = [UIFont getSizeForCHFont:CHFontStyleSmaller forPreferedContentSize: preferredContentSizeCategory];
    normalFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize: preferredContentSizeCategory];
    bigBoldFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize: preferredContentSizeCategory];
    self.labelName.font = bigBoldFont;
    self.labelNameOriginal.font = normalFont;
    self.labelDurationGenres.font = smallerFont;
    self.textViewSynopsis.font = normalFont;
    self.labelScoreImdb.font = normalFont;
    self.labelScoreMetacritic.font = normalFont;
    self.labelScoreRottenTomatoes.font = normalFont;
    self.labelDirector.font = normalFont;
    self.labelBuscarHorarios.font = normalFont;
    self.labelVideos.font = normalFont;
    ((UILabel *)[self.labelScoreImdb.superview viewWithTag:102]).font = normalFont;
    ((UILabel *)[self.labelScoreMetacritic.superview viewWithTag:102]).font = normalFont;
    ((UILabel *)[self.labelScoreRottenTomatoes.superview viewWithTag:102]).font = normalFont;
}
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    [self setFontsWithPreferedContentSizeCategory:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
    [self.collectionViewActors reloadData];
}


#pragma mark - Collection View Methods

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
        return self.movie.images.count;
    }
    else {
        return self.movie.actors.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // COLLECTION VIEW IMAGENES
    if ([collectionView isEqual:self.collectionView]) {
        NSString *imagePath = self.movie.images[indexPath.row];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        
        [imageView setImageWithStringURL:imagePath movieImageType:MovieImageTypeMovieImageCover];
    }
    // COLLECTION VIEW REPARTO
    else  {
        Actor *actor = self.movie.actors[indexPath.row];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        UILabel *label = (UILabel *)[cell viewWithTag:101];
        
        label.text = actor.name;
        label.font = smallerFont;
        [imageView setImageWithStringURL:actor.imageUrl movieImageType:MovieImageTypeMovieImageCover];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        MovieImagesVC *viewController = [self instantiateMovieImagesVC];
        [self pushPhotoBrowserWithIntermediateViewController:viewController index:indexPath.row];
    }
    else {
        NSUInteger row = self.movie.directors.count + indexPath.row;
        CastVC *viewController = [self instantiateCastVC];
        [self pushPhotoBrowserWithIntermediateViewController:viewController index:row];
    }
}

#pragma mark - Photo Browser View Controller Push Methods

- (MovieImagesVC *) instantiateMovieImagesVC {
    MovieImagesVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieImagesVC"];
    viewController.imagesURL = self.movie.images;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MovieImageType movieImageType;
    if ([defaults boolForKey:@"Retina Images"]) {
        movieImageType = MovieImageTypeMovieImageFullScreenRetina;
    }
    else {
        movieImageType = MovieImageTypeMovieImageFullScreenNoRetina;
    }
    viewController.photos = [NSMutableArray array];
    for (NSString *imagePath in self.movie.images) {
        [viewController.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:imagePath imageType:movieImageType]]]];
    }
    return viewController;
}
- (CastVC *) instantiateCastVC {
    CastVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CastVC"];
    [self setPropertyValuesToCastVC:viewController];
    return viewController;
}
- (void) setPropertyValuesToCastVC:(CastVC *)castVC {
    castVC.directors = self.movie.directors;
    castVC.actors = self.movie.actors;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MovieImageType movieImageType;
    if ([defaults boolForKey:@"Retina Images"]) {
        movieImageType = MovieImageTypeCastFullScreenRetina;
    }
    else {
        movieImageType = MovieImageTypeCastFullScreenNoRetina;
    }
    castVC.photos = [NSMutableArray array];
    for (Actor *director in self.movie.directors) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:director.imageUrl imageType:movieImageType]]];
        photo.caption = [NSString stringWithFormat:@"Nombre: %@\nDirector",director.name];
        [castVC.photos addObject:photo];
    }
    for (Actor *actor in self.movie.actors) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:actor.imageUrl imageType:movieImageType]]];
        photo.caption = [NSString stringWithFormat:@"Nombre: %@",actor.name];
        if (!actor.character || ![actor.character isEqualToString:@""]) {
            photo.caption = [photo.caption stringByAppendingFormat:@"\nPersonaje: %@",actor.character];
        }
        [castVC.photos addObject:photo];
    }
}
- (void) pushPhotoBrowserWithIntermediateViewController:(UIViewController *)viewController index:(NSUInteger)index{
    
    GlobalNavigationController *nvc = (GlobalNavigationController *)self.navigationController;
    nvc.transitionPanGesture.enabled = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)viewController];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    [browser setCurrentPhotoIndex:index]; // Example: allows second image to be presented first
    // Present
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers addObjectsFromArray:@[viewController, browser]];
    [self.navigationController setViewControllers:[NSArray arrayWithArray:viewControllers] animated:YES];
}
#pragma mark - Push Photo VCs

-(IBAction)pushPhotoCollection:(id)sender {
    MovieImagesVC *viewController = [self instantiateMovieImagesVC];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)pushCastVC:(id)sender {
    CastVC *viewController = [self instantiateCastVC];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)pushMovieCover:(id)sender {
    MovieImagesVC *viewController = [self instantiateMovieImagesVC];
    [self pushPhotoBrowserWithIntermediateViewController:viewController index:self.movie.images.count-1];
}
-(IBAction)pushPortraitImage:(id)sender {
    MovieImagesVC *viewController = [self instantiateMovieImagesVC];
    for (int i=0; i<self.movie.images.count; i++) {
        if ([self.movie.images[i] isEqualToString:self.portraitImageURL]) {
            [self pushPhotoBrowserWithIntermediateViewController:viewController index:i];
            break;
        }
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MovieToCast"]) {
        CastVC *castVC = [segue destinationViewController];
        [self setPropertyValuesToCastVC:castVC];
    }
    else if ([[segue identifier] isEqualToString:@"MovieToWeb"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WebVC *wvc = [segue destinationViewController];
        if (indexPath.row == 0) {
            wvc.urlString = self.movie.urlMetacritic;
        }
        else if (indexPath.row == 1) {
            wvc.urlString = [NSString stringWithFormat:@"http://m.imdb.com/title/%@/",self.movie.urlImdb];
        }
        else if (indexPath.row == 2) {
            wvc.urlString = self.movie.urlRottenTomatoes;
        }
    }
    else if ([[segue identifier] isEqualToString:@"MovieToShowtimes"]){
        MovieCinemasVC *vc = (MovieCinemasVC *)[segue destinationViewController];
        vc.movieID = self.movie.itemId;
        vc.movieName = self.movie.name;
    }
    else if ([[segue identifier] isEqualToString:@"MovieToVideos"]) {
        VideoVC *videoVC = segue.destinationViewController;
        videoVC.videos = self.movie.videos;
    }
}

#pragma mark - Interface Orientation

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Setup Views
-(void) setupViews{
    
    UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(-4.f, 0.f, self.coverImageView.frame.size.width+14.f, self.coverImageView.frame.size.height+10.f)];
    self.textViewSynopsis.textContainer.exclusionPaths = @[exclusionPath];
    
    self.viewOverPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.viewOverPortrait.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.labelName = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelName.textColor = [UIColor whiteColor];
    self.labelNameOriginal = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelNameOriginal.textColor = [UIColor whiteColor];
    self.labelDurationGenres = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelDurationGenres.textColor = [UIColor whiteColor];
    
    NSDictionary *viewsDictionary = @{
                                      @"name": self.labelName,
                                      @"nameOriginal": self.labelNameOriginal,
                                      @"durationGenres": self.labelDurationGenres,
                                      @"viewOverPortrait": self.viewOverPortrait
                                      };
    for (UIView *view in [viewsDictionary allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.portraitImageView.superview addSubview:self.viewOverPortrait];
    [self.viewOverPortrait addSubview:self.labelName];
    [self.viewOverPortrait addSubview:self.labelNameOriginal];
    [self.viewOverPortrait addSubview:self.labelDurationGenres];
    
    [self.portraitImageView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewOverPortrait]|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:viewsDictionary]];
    [self.portraitImageView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewOverPortrait]-(-1)-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:viewsDictionary]];
    
    
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[name]-1-[nameOriginal]-1-[durationGenres]-3-|"
                                                                                  options:NSLayoutFormatAlignAllLeft
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[name]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[nameOriginal]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[durationGenres]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    
}
@end
