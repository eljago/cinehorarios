
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
#import "MovieImagesVC.h"
#import "CastVC.h"
#import "WebVC.h"
#import "UIImageView+CH.h"
#import "MWPhoto.h"
#import "MBProgressHUD.h"
#import "MovieCinemasVC.h"
#import "VideoVC.h"
#import "GAI+CH.h"
#import "UIView+CH.h"
#import "GlobalNavigationController.h"
#import "Person.h"
#import "ArrayDataSource.h"
#import "MovieImageCell.h"
#import "MovieImageCell+MovieImage.h"
#import "MovieCastCell.h"
#import "MovieCastCell+Person.h"
#import "Cast.h"
#import "RFRateMe.h"
#import "UIViewController+DoAlertView.h"
#import "NSObject+Utilidades.h"

@interface MovieVC () <UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMovieNameTrailing;
@property (weak, nonatomic) IBOutlet UITextView *textViewSynopsis;
@property (weak, nonatomic) IBOutlet UIView *viewOverLabelMovieName;
@property (weak, nonatomic) IBOutlet UILabel *labelMovieName;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic, strong) Movie *movie;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewActors;

@property (nonatomic, weak) IBOutlet UILabel *labelDirector;

@property (nonatomic, weak) IBOutlet UILabel *labelScoreMetacritic;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreImdb;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreRottenTomatoes;
@property (nonatomic, weak) IBOutlet UILabel *labelBuscarHorarios;
@property (nonatomic, weak) IBOutlet UILabel *labelVideos;

@property (nonatomic, strong) Cast *cast;

@property (nonatomic, strong) ArrayDataSource *collectionViewImagesDataSource;
@property (nonatomic, strong) ArrayDataSource *collectionViewCastDataSource;

@property (nonatomic, strong) UIFont *smallerFont;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *bigBoldFont;
@end

@implementation MovieVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupDataSources];
    
    UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 90, 30)];
    self.textViewSynopsis.textContainer.exclusionPaths = @[exclusionPath];
    
    [GAI trackPage:@"INFO PELICULA"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Peliculas Visitadas" label:self.movieName];
    
    // TopView it's the view over the tableview while it's downloading the data for the first time
    UIView *topView = [[UIView alloc] initWithFrame:self.view.bounds];
    topView.backgroundColor = [UIColor tableViewColor];
    topView.tag = 999;
    [self.view addSubview:topView];
    
    // Defining and setting fonts
    [self setFontsWithPreferedContentSizeCategory: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [RFRateMe showRateAlert];
    
    if (self.portraitImageURL) {
        [self.portraitImageView setImageWithStringURL:self.portraitImageURL movieImageType:MovieImageTypePortrait placeholderImage:nil];
    }
    if (self.coverImageURL) {
        [self.coverImageView setImageWithStringURL:self.coverImageURL movieImageType:MovieImageTypeCover];
    }
//    self.constraintMovieNameTrailing.constant = -self.viewOverLabelMovieName.bounds.size.width;
    
    [self getMovieForceRemote:NO];
}

-(void) setupDataSources {
    self.collectionViewImagesDataSource = [[ArrayDataSource alloc] initWithItems:self.movie.images cellIdentifier:@"Cell" configureCellBlock:^(MovieImageCell *cell, NSString *imageURL) {
        [cell configureForImageURL:imageURL];
    }];
    self.collectionView.dataSource = self.collectionViewImagesDataSource;
    
    self.collectionViewCastDataSource = [[ArrayDataSource alloc] initWithItems:self.cast.actors cellIdentifier:@"Cell" configureCellBlock:^(MovieCastCell *cell, Person *person) {
        [cell configureForPerson:person font:self.smallerFont];
    }];
    self.collectionViewActors.dataSource = self.collectionViewCastDataSource;
}

#pragma mark Row & Height Calculators

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1 && self.cast.directors.count == 0) {
        return 0.01f;
    }
    else if (section == 2 && self.cast.actors.count == 0) {
        return 0.01f;
    }
    else if (section == 3 && self.movie.images.count == 0) {
        return 0.01f;
    }
    else {
        return [UIView heightForHeaderViewWithText:@"Javier"];
    }
}

#pragma mark - Fetch Data

- (void) getMovieForceRemote:(BOOL) forceRemote {
    if (forceRemote) {
        [self downloadMovie];
    }
    else {
        self.movie = [Movie loadMovieWithMovieID:self.movieID];
        if (self.movie) {
            [self setPeople];
            self.collectionViewImagesDataSource.items = self.movie.images;
            self.collectionViewCastDataSource.items = self.cast.actors;
            [self setupTableViews];
            [self.tableView reloadData];
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            [self downloadMovie];
        }
    }
}
- (void) downloadMovie {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Movie getCinemaWithBlock:^(Movie *movie, NSError *error) {
        if (!error) {
            self.movie = movie;
            [self setPeople];
            self.collectionViewImagesDataSource.items = self.movie.images;
            self.collectionViewCastDataSource.items = self.cast.actors;
            [self setupTableViews];
            [self.tableView reloadData];
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

#pragma mark Set Actors & Directors

-(void) setPeople {
    
    NSMutableArray *actorsMutable = [[NSMutableArray alloc] init];
    NSMutableArray *directorsMutable = [[NSMutableArray alloc] init];
    for (Person *person in self.movie.people) {
        
        if (person.actor) {
            [actorsMutable addObject:person];
        }
        if (person.director) {
            [directorsMutable addObject:person];
        }
    }
    self.cast = [[Cast alloc] initWithDirectors:[NSArray arrayWithArray:directorsMutable] actors:[NSArray arrayWithArray:actorsMutable]];
}


#pragma mark - Set TableView values

- (void) setupTableViews {
    
    if (self.movie.information) {
        self.textViewSynopsis.text = self.movie.information;
    }
    else {
        self.textViewSynopsis.hidden = YES;
    }
    
    if (self.movie.name) {
        self.labelMovieName.text = self.movie.name;
    }
    
    if (self.cast.directors.count != 0) {
        Person *director = [self.cast.directors firstObject];
        self.labelDirector.text = director.name;
        if (self.cast.directors.count > 1) {
            for (int i=1; i<self.cast.directors.count; i++) {
                Person *director2 = self.cast.directors[i];
                self.labelDirector.text = [self.labelDirector.text stringByAppendingFormat:@", %@",director2.name];
            }
        }
    }
    if (self.cast.actors.count == 0) {
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
    
    if (self.movie.imdbScore) {
        self.labelScoreImdb.text = [NSString stringWithFormat:@"%.1f / 10",[self.movie.imdbScore longValue] / 10.];
    }
    else {
        self.labelScoreImdb.text = @"?";
    }
    if (self.movie.metacriticScore) {
        self.labelScoreMetacritic.text = [NSString stringWithFormat:@"%ld / 100",[self.movie.metacriticScore longValue]];
    }
    else {
        self.labelScoreMetacritic.text = @"?";
    }
    if (self.movie.rottenTomatoesScore) {
        self.labelScoreRottenTomatoes.text = [NSString stringWithFormat:@"%ld %%",[self.movie.rottenTomatoesScore longValue]];
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
//        [self.viewOverLabelMovieName.superview layoutIfNeeded];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.constraintMovieNameTrailing.constant = 0;
//            [self.viewOverLabelMovieName.superview layoutIfNeeded];
//        }];
    }];
}

#pragma mark - UITableViewController
#pragma mark Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ((!self.movie.rottenTomatoesURL || [self.movie.rottenTomatoesURL isEqualToString:@""]) &&
        (!self.movie.imdbCode || [self.movie.imdbCode isEqualToString:@""]) &&
        (!self.movie.metacriticURL || [self.movie.metacriticURL isEqualToString:@""])) {
        return 4;
    }
    else {
        return 5;
    }
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGSize size = [self.textViewSynopsis sizeThatFits:CGSizeMake(self.textViewSynopsis.frame.size.width, CGFLOAT_MAX)];
            return self.textViewSynopsis.frame.origin.y + size.height + 10;
        }
        else if (indexPath.row == 1) {
            if (self.movie.videos.count == 0) {
                return 0.;
            }
        }
        else if (indexPath.row == 2) {
            if (!self.movie.hasFunctions) {
                return 0.;
            }
        }
    }
    else if (indexPath.section == 1) {
        if (self.cast.directors.count == 0) {
            return 0.;
        }
        else {
            CGSize size = CGSizeMake(277.f, FLT_MAX);
            
            NSMutableArray *directorsNames = [[NSMutableArray alloc] init];
            for (Person *director in self.cast.directors) {
                [directorsNames addObject:director.name];
            }
            CGRect nameLabelRect = [[directorsNames componentsJoinedByString:@", "] boundingRectWithSize: size
                                                                                                 options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                              attributes: [NSDictionary dictionaryWithObject:self.normalFont forKey:NSFontAttributeName]
                                                                                                 context: nil];
            
            CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
            
            return totalHeight;
        }
    }
    else if (indexPath.section == 2) {
        if (self.movie.people.count == 0) {
            return 0.;
        }
    }
    else if (indexPath.section == 3) {
        if (self.movie.images.count == 0) {
            return 0.;
        }
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0){
            if (!self.movie.metacriticURL || [self.movie.metacriticURL isEqualToString:@""]) {
                return 0.;
            }
        }
        else if(indexPath.row == 1){
            if (!self.movie.imdbCode || [self.movie.imdbCode isEqualToString:@""]) {
                return 0.;
            }
        }
        else if (indexPath.row == 2){
            if (!self.movie.rottenTomatoesURL || [self.movie.rottenTomatoesURL isEqualToString:@""]) {
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
            if (self.cast.directors.count > 1) {
                text = @"Directores";
            }
            else if(self.cast.directors.count == 1){
                text = @"Director";
            }
            else {
                return [UIView new];
            }
            break;
        case 2:
            if (self.cast.actors.count == 0) {
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
    NSInteger height = [UIView heightForHeaderViewWithText:text];
    return [UIView headerViewForText:text height:height];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 4 && indexPath.row == 1)) {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        MovieImagesVC *viewController = [self instantiateMovieImagesVC];
        [self pushPhotoBrowserWithIntermediateViewController:viewController index:indexPath.row];
    }
    else {
        NSUInteger row = self.cast.directors.count + indexPath.row;
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
    castVC.cast = self.cast;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MovieImageType movieImageType;
    if ([defaults boolForKey:@"Retina Images"]) {
        movieImageType = MovieImageTypeCastFullScreenRetina;
    }
    else {
        movieImageType = MovieImageTypeCastFullScreenNoRetina;
    }
    castVC.photos = [NSMutableArray array];
    for (Person *director in self.cast.directors) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:director.imageURL imageType:movieImageType]]];
        photo.caption = [NSString stringWithFormat:@"Nombre: %@\nDirector",director.name];
        [castVC.photos addObject:photo];
    }
    for (Person *actor in self.cast.actors) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:actor.imageURL imageType:movieImageType]]];
        photo.caption = [NSString stringWithFormat:@"Nombre: %@",actor.name];
        if (!actor.character || ![actor.character isEqualToString:@""]) {
            photo.caption = [photo.caption stringByAppendingFormat:@"\nPersonaje: %@",actor.character];
        }
        [castVC.photos addObject:photo];
    }
}
- (void) pushPhotoBrowserWithIntermediateViewController:(UIViewController *)viewController index:(NSUInteger)index{
        
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
            wvc.urlString = self.movie.metacriticURL;
        }
        else if (indexPath.row == 1) {
            wvc.urlString = [NSString stringWithFormat:@"http://m.imdb.com/title/%@/",self.movie.imdbCode];
        }
        else if (indexPath.row == 2) {
            wvc.urlString = self.movie.rottenTomatoesURL;
        }
    }
    else if ([[segue identifier] isEqualToString:@"MovieToShowtimes"]){
        MovieCinemasVC *vc = (MovieCinemasVC *)[segue destinationViewController];
        vc.movieID = self.movie.movieID;
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

#pragma mark - Notification Observer method

-(void) setFontsWithPreferedContentSizeCategory:(NSString *)preferredContentSizeCategory {
    self.smallerFont = [UIFont getSizeForCHFont:CHFontStyleSmaller forPreferedContentSize: preferredContentSizeCategory];
    self.normalFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize: preferredContentSizeCategory];
    self.bigBoldFont = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize: preferredContentSizeCategory];
    self.labelMovieName.font = self.bigBoldFont;
    self.textViewSynopsis.font = self.normalFont;
    self.labelScoreImdb.font = self.normalFont;
    self.labelScoreMetacritic.font = self.normalFont;
    self.labelScoreRottenTomatoes.font = self.normalFont;
    self.labelDirector.font = self.normalFont;
    self.labelBuscarHorarios.font = self.normalFont;
    self.labelVideos.font = self.normalFont;
    ((UILabel *)[self.labelScoreImdb.superview viewWithTag:102]).font = self.normalFont;
    ((UILabel *)[self.labelScoreMetacritic.superview viewWithTag:102]).font = self.normalFont;
    ((UILabel *)[self.labelScoreRottenTomatoes.superview viewWithTag:102]).font = self.normalFont;
}
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    [self setFontsWithPreferedContentSizeCategory:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
    [self.collectionViewActors reloadData];
}

@end
