//
//  MovieViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieViewController.h"
#import "CHViewTableController_Protected.h"
#import "GAI+CH.h"
#import "Movie.h"
#import "Person.h"
#import "Cast.h"
#import "ArrayDataSource.h"
#import "CastVC.h"
#import "UIView+CH.h"
#import "WebVC.h"
#import "VideoVC.h"
#import "MovieFunctionsContainerVC.h"

#import "MBProgressHUD+CH.h"
#import "UIImageView+CH.h"

#import "MovieCellTop.h"
#import "MovieCellTop+Movie.h"
#import "MovieCellTextView.h"
#import "MovieCellTextView+Movie.h"
#import "MovieCellImageLabel.h"
#import "MovieCellImageLabel+Movie.h"
#import "MovieCellCast.h"
#import "MovieCellCast+Movie.h"
#import "MovieCellDirectors.h"
#import "MovieCellDirectors+Movie.h"
#import "MovieCellImages.h"
#import "MovieCellImages+Movie.h"
#import "MovieCastCell.h"
#import "MovieCastCell+Person.h"
#import "MovieImageCell.h"
#import "MovieImageCell+MovieImage.h"
#import "MovieCellRating.h"
#import "MovieCellRating+Movie.h"

#import "UIViewController+WebOpener.h"

@interface MovieViewController () <UITableViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *tableViewCells;

@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) Cast *cast;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *thumbPhotos;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GAI trackPage:@"INFO PELICULA"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Peliculas Visitadas" label:self.movieName];
        
    [self getMovieForceRemote:NO];
    
    self.title = self.movieName;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Atrás"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning");
}

#pragma mark - Fetch Data

- (void) getMovieForceRemote:(BOOL) forceRemote {
    if (forceRemote) {
        [self downloadMovie];
    }
    else {
        self.movie = [Movie loadMovieWithMovieID:self.movieID];
        if (self.movie) {
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
    [Movie getCinemaWithBlock:^(Movie *movie, NSError *error) {
        if (!error) {
            self.movie = movie;
            [self setupTableViews];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } movieID:self.movieID];
}
-(void)refreshData {
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
    [self setPeople];
    
    NSMutableArray *arrayCells = [NSMutableArray new]; // hold the rows of a section
    NSMutableArray *sectionArray = [NSMutableArray new]; // holds all section arrays
    
    // SECTION 1
    if (self.coverImageURL.length > 0 || self.portraitImageURL.length > 0) {
        MovieCellTop *movieCell0 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellTop"];
        [movieCell0 configureForMovie:self.movie coverImageURL:self.coverImageURL portraitImageURL:self.portraitImageURL];
        [sectionArray addObject:movieCell0];
    }
    if (self.movie.year || self.movie.rating || self.movie.nameOriginal.length > 0 || self.movie.duration || self.movie.debut.length > 0) {
        MovieCellTextView *movieCell1 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellTextView"];
        movieCell1.tag = 201;
        [movieCell1 configureMovieInfoForMovie:self.movie boldFont:self.fontBigBold normalFont:self.fontNormal smallerFont:self.fontSmaller smallestBoldFont:self.fontSmallestBold];
        [sectionArray addObject:movieCell1];
    }
    if (self.movie.information.length > 0) {
        MovieCellTextView *movieCell1 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellTextView"];
        movieCell1.tag = 200;
        [movieCell1 configureSynpsisForMovie:self.movie];
        [sectionArray addObject:movieCell1];
    }
    if (self.movie.videos.count > 0) {
        MovieCellImageLabel *movieCell2 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellImageLabel"];
        movieCell2.tag = 601;
        [movieCell2 configureVideosCellForMovie:self.movie];
        [sectionArray addObject:movieCell2];
    }
    if (self.movie.hasFunctions) {
        MovieCellImageLabel *movieCell2 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellImageLabel"];
        movieCell2.tag = 600;
        [movieCell2 configureShowtimesCellForMovie:self.movie];
        [sectionArray addObject:movieCell2];
        
        UIBarButtonItem *menuButtonHorarios = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconHorarios"] style:UIBarButtonItemStylePlain target:self action:@selector(goToFunciones)];
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
        self.navigationItem.rightBarButtonItems = @[menuButtonItem, menuButtonHorarios];
    }
    if (sectionArray.count > 0) {
        [arrayCells addObject:[NSArray arrayWithArray:sectionArray]];
    }
    
    sectionArray = [NSMutableArray new];
    
    if (self.cast.directors.count > 0) {
        MovieCellDirectors *movieCell4 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellDirectors"];
        [movieCell4 configureCellForDirectors:self.cast.directors];
        [sectionArray addObject:movieCell4];
    }
    if (sectionArray.count > 0) {
        [arrayCells addObject:[NSArray arrayWithArray:sectionArray]];
    }
    
    // SECTION 2
    sectionArray = [NSMutableArray new];
    if (self.cast.actors.count > 0) {
        MovieCellCast *movieCell3 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellCast"];
        [movieCell3 configureForActors:self.cast.actors font:self.fontSmall];
        [sectionArray addObject:movieCell3];
    }
    if (sectionArray.count > 0) {
        [arrayCells addObject:[NSArray arrayWithArray:sectionArray]];
    }
    
    // SECTION 3
    sectionArray = [NSMutableArray new];
    if (self.movie.images.count > 0) {
        MovieCellImages *movieCell5 = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellImages"];
        [movieCell5 configureForImages:self.movie.images];
        [sectionArray addObject:movieCell5];
    }
    if (sectionArray.count > 0) {
        [arrayCells addObject:[NSArray arrayWithArray:sectionArray]];
    }
    
    // SECTION 4
    sectionArray = [NSMutableArray new];
    if (![self.movie.imdbCode isEqualToString:@""]) {
        MovieCellRating *movieCellRating = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellRating"];
        movieCellRating.tag = 300;
        NSString *score;
        if (self.movie.imdbScore) {
            score = [NSString stringWithFormat:@"%.1f / 10",[self.movie.imdbScore longValue] / 10.];
        }
        else {
            score = @"?";
        }
        [movieCellRating configureForRating:score image:[UIImage imageNamed:@"LogoImdb"] webpageName:@"Imdb"];
        [sectionArray addObject:movieCellRating];
    }
    if (![self.movie.metacriticURL isEqualToString:@""]) {
        MovieCellRating *movieCellRating = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellRating"];
        movieCellRating.tag = 301;
        NSString *score;
        if (self.movie.metacriticScore) {
            score = [NSString stringWithFormat:@"%ld / 100",[self.movie.metacriticScore longValue]];
        }
        else {
            score = @"?";
        }
        [movieCellRating configureForRating:score image:[UIImage imageNamed:@"LogoMetacritic"] webpageName:@"Metacritic"];
        [sectionArray addObject:movieCellRating];
    }
    if (![self.movie.rottenTomatoesURL isEqualToString:@""]) {
        MovieCellRating *movieCellRating = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCellRating"];
        movieCellRating.tag = 302;
        NSString *score;
        if (self.movie.rottenTomatoesScore) {
            score = [NSString stringWithFormat:@"%ld %%",[self.movie.rottenTomatoesScore longValue]];
        }
        else {
            score = @"?";
        }
        [movieCellRating configureForRating:score image:[UIImage imageNamed:@"LogoRottenTomatoes"] webpageName:@"Rotten Tomatoes"];
        [sectionArray addObject:movieCellRating];
    }
    if (sectionArray.count > 0) {
        [arrayCells addObject:[NSArray arrayWithArray:sectionArray]];
    }
    
    
    self.tableViewCells = [NSArray arrayWithArray:arrayCells];
}


#pragma mark - UITableView
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewCells count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewCells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableViewCells[indexPath.section][indexPath.row];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MovieCellTop class]]) {
        MovieCellTop *movieCell0 = (MovieCellTop *)cell;
        [movieCell0.superview bringSubviewToFront:movieCell0];
    }
    if ([cell isKindOfClass:[MovieCellTextView class]]) {
        MovieCellTextView *movieCell1 = (MovieCellTextView *)cell;
        if (cell.tag == 201) {
            [movieCell1 configureMovieInfoForMovie:self.movie boldFont:self.fontBigBold normalFont:self.fontNormal smallerFont:self.fontSmaller smallestBoldFont:self.fontSmallestBold];
        }
        else {
            movieCell1.textView.font = self.fontNormal;
        }
    }
    if ([cell isKindOfClass:[MovieCellImageLabel class]]) {
        MovieCellImageLabel *movieCell2 = (MovieCellImageLabel *)cell;
        movieCell2.labelCell.font = self.fontNormal;
    }
    if ([cell isKindOfClass:[MovieCellRating class]]) {
        MovieCellRating *movieCellRating = (MovieCellRating *)cell;
        movieCellRating.labelWebPage.font = self.fontNormal;
        movieCellRating.labelScore.font = self.fontNormal;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.tableViewCells[indexPath.section][indexPath.row];
    if ([cell isKindOfClass:[MovieCellTop class]]) {
        return [MovieCellTop heightForRow];
    }
    if ([cell isKindOfClass:[MovieCellTextView class]]) {
        MovieCellTextView *movieCell1 = (MovieCellTextView *)cell;
        if (cell.tag == 201) {
            return [movieCell1 heightForAttributedTextView];
        }
        else {
            return [movieCell1 heightForRowWithFont:self.fontNormal];
        }
    }
    if ([cell isKindOfClass:[MovieCellImageLabel class]]) {
        return [MovieCellImageLabel heightForRow];
    }
    if ([cell isKindOfClass:[MovieCellCast class]]) {
        return [MovieCellCast heightForRow];
    }
    if ([cell isKindOfClass:[MovieCellDirectors class]]) {
        return [MovieCellDirectors heightForRowWithFont:self.fontSmall directors:self.cast.directors];
    }
    if ([cell isKindOfClass:[MovieCellImages class]]) {
        return [MovieCellImages heightForRow];
    }
    if ([cell isKindOfClass:[MovieCellRating class]]) {
        return [MovieCellRating heightForRow];
    }
    
    return 0.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [self.tableViewCells[section] firstObject];
    if ([cell isKindOfClass:[MovieCellDirectors class]]) {
        if (self.cast.directors.count > 1) {
            return [UIView headerViewForText:@"Directores" height:0];
        }
        else {
            return [UIView headerViewForText:@"Director" height:0];
        }
    }
    if ([cell isKindOfClass:[MovieCellCast class]]) {
        return [UIView headerViewForText:@"Reparto" height:0];
    }
    if ([cell isKindOfClass:[MovieCellImages class]]) {
        return [UIView headerViewForText:@"Imágenes" height:0];
    }
    if ([cell isKindOfClass:[MovieCellRating class]]) {
        return [UIView headerViewForText:@"Calificaciones" height:0];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [self.tableViewCells[section] firstObject];
    if ([cell isKindOfClass:[MovieCellDirectors class]] || [cell isKindOfClass:[MovieCellCast class]] || [cell isKindOfClass:[MovieCellImages class]] || [cell isKindOfClass:[MovieCellRating class]]) {
        return [UIView heightForHeaderViewWithText:@"Arturo"];
    }
    return 0.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = self.tableViewCells[indexPath.section][indexPath.row];
    if ([cell isKindOfClass:[MovieCellRating class]]) {
        if (cell.tag == 300) { // IMDB
            NSString *webToOpenUrlString = [NSString stringWithFormat:@"http://www.imdb.com/title/%@/",self.movie.imdbCode];
            NSString *imdbAppUrlString = [NSString stringWithFormat:@"imdb:///title/%@/",self.movie.imdbCode];
            [self goWebPageWithUrlString:webToOpenUrlString imdbAppUrlString:imdbAppUrlString];
        }
        else if (cell.tag == 301) { // METACRITIC
            NSString *webToOpenUrlString = self.movie.metacriticURL;
            NSString *imdbAppUrlString = nil;
            [self goWebPageWithUrlString:webToOpenUrlString imdbAppUrlString:imdbAppUrlString];
        }
        else if (cell.tag == 302) { // ROTTEN TOMATOES
            NSString *webToOpenUrlString = self.movie.rottenTomatoesURL;
            NSString *imdbAppUrlString = nil;
            [self goWebPageWithUrlString:webToOpenUrlString imdbAppUrlString:imdbAppUrlString];
        }
    }
    else if ([cell isKindOfClass:[MovieCellImageLabel class]]) {
        if (cell.tag == 600) {
            [self goToFunciones];
        }
        else if (cell.tag == 601 ) {
            VideoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoVC"];
            vc.videos = self.movie.videos;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void) goToFunciones {
    MovieFunctionsContainerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieFunctionsContainerVC"];
    vc.movieID = self.movieID;
    vc.movieName = self.movieName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Push View Controllers Methods

- (void) prepareToPushPhotoBrowserWithGrid {
    MovieImageType movieImageType = [UIImageView getFullscreenMovieImageType];
    
    self.photos = nil;
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSString *imagePath in self.movie.images) {
        [mutArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:imagePath imageType:movieImageType]]]];
    }
    self.photos = mutArray;
    
    self.thumbPhotos = nil;
    mutArray = [NSMutableArray new];
    for (NSString *imagePath in self.movie.images) {
        [mutArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[UIImageView imageURLForPath:imagePath imageType:MovieImageTypeCover]]]];
    }
    self.thumbPhotos = mutArray;
}
- (CastVC *) instantiateCastVC {
    CastVC *castVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastVC"];
    [self setPropertyValuesToCastVC:castVC];
    return castVC;
}
- (void) setPropertyValuesToCastVC:(CastVC *)castVC {
    castVC.cast = self.cast;
    MovieImageType movieImageType = [UIImageView getFullscreenMovieImageType];
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
- (MWPhotoBrowser *) getPhotoBrowserWithIndex:(NSUInteger) index {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.enableGrid = YES;
    [browser setCurrentPhotoIndex:index];
    return browser;
}

#pragma mark Gesture Recognizer IBActions

-(IBAction)pushPhotoCollection:(id)sender {
    MWPhotoBrowser *browser = [self getPhotoBrowserWithIndex:0];
    [self prepareToPushPhotoBrowserWithGrid];
    browser.startOnGrid = YES;
    [self.navigationController pushViewController:browser animated:YES];
}
-(IBAction)pushCastVC:(id)sender {
    CastVC *viewController = [self instantiateCastVC];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)pushMovieCover:(id)sender {
    [self prepareToPushPhotoBrowserWithGrid];
    MWPhotoBrowser *browser = [self getPhotoBrowserWithIndex:self.movie.images.count-1];
    [self.navigationController pushViewController:browser animated:YES];
}
-(IBAction)pushPortraitImage:(id)sender {
    MWPhotoBrowser *browser;
    [self prepareToPushPhotoBrowserWithGrid];
    for (int i=0; i<self.movie.images.count; i++) {
        if ([self.movie.images[i] isEqualToString:self.portraitImageURL]) {
            browser = [self getPhotoBrowserWithIndex:i];
            [self.navigationController pushViewController:browser animated:YES];
            break;
        }
    }
}
#pragma mark - Go imdb actor profile

-(IBAction)goImdb:(id)sender {
    UIButton *buttonImdb = (UIButton *)sender;
    MovieCastCell *castCell = (MovieCastCell *)buttonImdb.superview.superview;
    UICollectionView *collectionView = (UICollectionView *)castCell.superview;
    NSIndexPath *indexPath = [collectionView indexPathForCell: castCell];
    Person *person = (Person *)self.cast.actors[indexPath.row];
    
    NSString *webToOpenUrlString = [NSString stringWithFormat:@"http://www.imdb.com/name/%@/",person.imdbCode];
    NSString *imdbAppUrlString = [NSString stringWithFormat:@"imdb:///name/%@/",person.imdbCode];
    [self goWebPageWithUrlString:webToOpenUrlString imdbAppUrlString:imdbAppUrlString];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MovieImageCell class]]) {
        [self prepareToPushPhotoBrowserWithGrid];
        MWPhotoBrowser *browser = [self getPhotoBrowserWithIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
        
        
    }
    else if ([cell isKindOfClass:[MovieCastCell class]]) {
        NSUInteger row = self.cast.directors.count + indexPath.row;
        CastVC *castVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastVC"];
        [self setPropertyValuesToCastVC:castVC];
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)castVC];
        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        [browser setCurrentPhotoIndex:row]; // Example: allows second image to be presented first
        
        // Present
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers addObjectsFromArray:@[castVC, browser]];
        [self.navigationController setViewControllers:[NSArray arrayWithArray:viewControllers] animated:YES];
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MovieCastCell class]]) {
        MovieCastCell *movieCastCell = (MovieCastCell *)cell;
        movieCastCell.nameLabel.font = self.fontSmall;
    }
}

#pragma mark PhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    return [self.thumbPhotos objectAtIndex:index];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MovieToCast"] || [[segue identifier] isEqualToString:@"MovieToDirectorCast"]) {
        CastVC *castVC = [segue destinationViewController];
        [self setPropertyValuesToCastVC:castVC];
    }
}

@end
