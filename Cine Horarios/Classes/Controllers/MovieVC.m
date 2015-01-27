
//  MovieVCViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 09-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieVC.h"
#import "Movie.h"
#import "CastVC.h"
#import "WebVC.h"
#import "MWPhoto.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+CH.h"
#import "MovieFunctionsVC.h"
#import "VideoVC.h"
#import "Person.h"
#import "ArrayDataSource.h"
#import "MovieImageCell.h"
#import "MovieImageCell+MovieImage.h"
#import "MovieCastCell.h"
#import "MovieCastCell+Person.h"
#import "Cast.h"
#import "RFRateMe.h"
#import "NSObject+Utilidades.h"
#import "OpenInChromeController.h"
#import "GAI+CH.h"

#import "UIView+CH.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "UITextView+CH.h"
#import "UIImageView+CH.h"

@interface MovieVC () <UICollectionViewDelegate, MWPhotoBrowserDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIFont *fontNormal;
@property (nonatomic, strong) UIFont *fontBigBold;
@property (nonatomic, strong) UIFont *fontSmall;
@property (nonatomic, strong) OpenInChromeController *openInChromeController;
@property (nonatomic, assign, readonly) CHDownloadStat downloadStatus;

@property (weak, nonatomic) IBOutlet UITextView *textViewSynopsis;
@property (weak, nonatomic) IBOutlet UITextView *textViewMovieDetails;
@property (weak, nonatomic) IBOutlet UIView *viewOverLabelMovieName;
@property (weak, nonatomic) IBOutlet UILabel *labelMovieName;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewActors;

@property (nonatomic, weak) IBOutlet UILabel *labelDirector;

@property (nonatomic, weak) IBOutlet UILabel *labelScoreMetacritic;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreImdb;
@property (nonatomic, weak) IBOutlet UILabel *labelScoreRottenTomatoes;
@property (nonatomic, weak) IBOutlet UILabel *labelMetacritic;
@property (nonatomic, weak) IBOutlet UILabel *labelImdb;
@property (nonatomic, weak) IBOutlet UILabel *labelRottenTomatoes;
@property (nonatomic, weak) IBOutlet UILabel *labelBuscarHorarios;
@property (nonatomic, weak) IBOutlet UILabel *labelVideos;

@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) Cast *cast;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *thumbPhotos;

@property (nonatomic, strong) NSString *imdbCodeSelected;

@property (nonatomic, strong) ArrayDataSource *collectionViewImagesDataSource;
@property (nonatomic, strong) ArrayDataSource *collectionViewCastDataSource;
@end

@implementation MovieVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupDataSources];
    
    self.photos = nil;
    
    [GAI trackPage:@"INFO PELICULA"];
    [GAI sendEventWithCategory:@"Preferencias Usuario" action:@"Peliculas Visitadas" label:self.movieName];
    
    // TopView it's the view over the tableview while it's downloading the data for the first time
    UIView *topView = [[UIView alloc] initWithFrame:self.view.bounds];
    topView.backgroundColor = [UIColor tableViewColor];
    topView.tag = 999;
    [self.view addSubview:topView];
    
    [RFRateMe showRateAlert];
    
    if (self.portraitImageURL) {
        [self.portraitImageView setImageWithStringURL:self.portraitImageURL movieImageType:MovieImageTypePortrait placeholderImage:nil];
    }
    if (self.coverImageURL) {
        [self.coverImageView setImageWithStringURL:self.coverImageURL movieImageType:MovieImageTypeCover];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    self.view.backgroundColor = [UIColor tableViewColor];
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.openInChromeController = [[OpenInChromeController alloc] init];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
    [self getMovieForceRemote:NO];
}

-(void) setupDataSources {
    self.collectionViewImagesDataSource = [[ArrayDataSource alloc] initWithItems:self.movie.images cellIdentifier:@"Cell" configureCellBlock:^(MovieImageCell *cell, NSString *imageURL) {
        [cell configureForImageURL:imageURL];
    }];
    self.collectionView.dataSource = self.collectionViewImagesDataSource;
    
    self.collectionViewCastDataSource = [[ArrayDataSource alloc] initWithItems:self.cast.actors cellIdentifier:@"Cell" configureCellBlock:^(MovieCastCell *cell, Person *person) {
        [cell configureForPerson:person font:self.fontSmall];
    }];
    self.collectionViewActors.dataSource = self.collectionViewCastDataSource;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - Attributes
- (UIFont *) fontNormal {
    if(_fontNormal) return _fontNormal;
    _fontNormal = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontNormal;
}
- (UIFont *) fontBigBold {
    if(_fontBigBold) return _fontBigBold;
    _fontBigBold = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontBigBold;
}
- (UIFont *) fontSmall {
    if(_fontSmall) return _fontSmall;
    _fontSmall = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize: [[UIApplication sharedApplication] preferredContentSizeCategory]];
    return _fontSmall;
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
        return [UIView heightForHeaderViewWithText:@"Arturo"];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES spinnerStyle:RTSpinKitViewStyleWave];
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
    
    if (self.movie.information) {
        self.textViewSynopsis.text = self.movie.information;
    }
    else {
        self.textViewSynopsis.hidden = YES;
    }
    
    if (self.movie.year || self.movie.rating || self.movie.nameOriginal.length > 0 || self.movie.duration || self.movie.debut.length > 0) {
        self.textViewMovieDetails.text = @"";
        BOOL placeLineBreak = NO;
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        if (self.movie.nameOriginal.length > 0) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Nombre Original: "
                                                                         attributes:@{NSFontAttributeName: self.fontBigBold}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:self.movie.nameOriginal
                                                                         attributes:@{NSFontAttributeName: self.fontNormal}]];
            placeLineBreak = YES;
        }
        if (self.movie.duration) {
            if (placeLineBreak)
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                             attributes:@{NSFontAttributeName: self.fontNormal}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Duración: "
                                                                         attributes:@{NSFontAttributeName: self.fontBigBold}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu minutos", (long)self.movie.duration.integerValue]
                                                                         attributes:@{NSFontAttributeName: self.fontNormal}]];
            placeLineBreak = YES;
        }
        if (self.movie.year) {
            if (placeLineBreak)
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                             attributes:@{NSFontAttributeName: self.fontNormal}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Año: "
                                                                         attributes:@{NSFontAttributeName: self.fontBigBold}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu",(long)self.movie.year.integerValue]
                                                                         attributes:@{NSFontAttributeName: self.fontNormal}]];
            placeLineBreak = YES;
        }
        if (self.movie.rating) {
            if (placeLineBreak)
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: self.fontNormal}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Calificación: "
                                                                         attributes:@{NSFontAttributeName: self.fontBigBold}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:self.movie.rating
                                                                         attributes:@{NSFontAttributeName: self.fontNormal}]];
            placeLineBreak = YES;
        }
        if (self.movie.debut > 0) {
            if (placeLineBreak)
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                             attributes:@{NSFontAttributeName: self.fontNormal}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Estreno: "
                                                                         attributes:@{NSFontAttributeName: self.fontBigBold}]];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:self.movie.debut
                                                                         attributes:@{NSFontAttributeName: self.fontNormal}]];
        }
        self.textViewMovieDetails.attributedText = text;
    }
    else {
        self.textViewMovieDetails.hidden = YES;
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
            return self.textViewSynopsis.frame.origin.y + [self.textViewSynopsis measureHeightUsingFont:self.fontNormal] + 10.f;
        }
        else if (indexPath.row == 1) {
            if (!self.movie.year && !self.movie.rating && self.movie.nameOriginal.length == 0 && !self.movie.duration && self.movie.debut.length == 0) {
                return 0.;
            }
            else {
                return self.textViewMovieDetails.frame.origin.y + [self.textViewMovieDetails measureHeightUsingFont:self.fontNormal] + 8.;
            }
        }
        else if (indexPath.row == 2) {
            if (self.movie.videos.count == 0) {
                return 0.;
            }
        }
        else if (indexPath.row == 3) {
            if (!self.movie.hasFunctions) {
                return 0.;
            }
            else {
                UIBarButtonItem *showtimesButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconHorarios"] style:UIBarButtonItemStylePlain target:self action:@selector(goToShowtimes:)];
                self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, showtimesButtonItem];
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
                                                                                              attributes: @{NSFontAttributeName: self.fontNormal}
                                                                                                 context: nil];
            
            CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
            
            return totalHeight;
        }
    }
    else if (indexPath.section == 2) {
        if (self.cast.actors.count == 0) {
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.textViewSynopsis.font = self.fontNormal;
            self.labelMovieName.font = self.fontNormal;
            cell.backgroundColor = [UIColor whiteColor];
        }
        else if (indexPath.row == 1) {
            self.textViewMovieDetails.font = self.fontNormal;
            cell.backgroundColor = [UIColor lighterGrayColor];
        }
        else if (indexPath.row == 2) {
            self.labelVideos.font = self.fontNormal;
            cell.backgroundColor = [UIColor whiteColor];
        }
        else if (indexPath.row == 3) {
            self.labelBuscarHorarios.font = self.fontNormal;
            cell.backgroundColor = [UIColor lighterGrayColor];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.labelDirector.font = self.fontNormal;
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            self.labelScoreMetacritic.font = self.fontNormal;
            self.labelMetacritic.font = self.fontNormal;
            cell.backgroundColor = [UIColor whiteColor];
        }
        else if (indexPath.row == 1) {
            self.labelScoreImdb.font = self.fontNormal;
            self.labelImdb.font = self.fontNormal;
            cell.backgroundColor = [UIColor lighterGrayColor];
        }
        else if (indexPath.row == 2) {
            self.labelScoreRottenTomatoes.font = self.fontNormal;
            self.labelRottenTomatoes.font = self.fontNormal;
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *urlString;
        switch (indexPath.row) {
            case 0:
                urlString = self.movie.metacriticURL;
                if ([[userDefaults stringForKey:@"CHOpenLinksMetacriticRottenTomatoes"] isEqualToString:@"Safari"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                }
                else if ([[userDefaults stringForKey:@"CHOpenLinksMetacriticRottenTomatoes"] isEqualToString:@"InApp"]) {
                    WebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
                    webVC.urlString = urlString;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                break;
            case 1:
                // OPEN IN IMDB APP
                if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"AppIMDB"]) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"imdb:///title/%@/",self.movie.imdbCode]];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    else {
                        NSURL *iTunesURL = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=342792525&mt=8"];
                        [[UIApplication sharedApplication] openURL:iTunesURL];
                    }
                }
                // OPEN IN SAFARI
                else if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"Safari"]) {
                    NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/title/%@/",self.movie.imdbCode];
                    NSURL *url = [NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:url];
                }
                // OPEN IN APP
                else if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"InApp"]) {
                    NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/title/%@/",self.movie.imdbCode];
                    WebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
                    webVC.urlString = urlString;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                break;
            case 2:
                urlString = self.movie.rottenTomatoesURL;
                if ([[userDefaults stringForKey:@"CHOpenLinksMetacriticRottenTomatoes"] isEqualToString:@"Safari"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                }
                else if ([[userDefaults stringForKey:@"CHOpenLinksMetacriticRottenTomatoes"] isEqualToString:@"InApp"]) {
                    WebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
                    webVC.urlString = urlString;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                break;
                
            default:
                return;
                break;
        }
    }
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        [self prepareToPushPhotoBrowserWithGrid];
        [self.navigationController pushViewController:[self getPhotoBrowserWithIndex:indexPath.row] animated:YES];
    }
    else {
        NSUInteger row = self.cast.directors.count + indexPath.row;
        CastVC *viewController = [self instantiateCastVC];
        MWPhotoBrowser *browser = [self getPhotoBrowserWithIntermediateViewController:viewController index:row];
        
        // Present
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers addObjectsFromArray:@[viewController, browser]];
        [self.navigationController setViewControllers:[NSArray arrayWithArray:viewControllers] animated:YES];
    }
}

#pragma mark - Photo Browser View Controller Push Methods

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

- (MWPhotoBrowser *) getPhotoBrowserWithIntermediateViewController:(UIViewController *)viewController index:(NSUInteger)index{
        
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)viewController];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    [browser setCurrentPhotoIndex:index]; // Example: allows second image to be presented first
    return browser;
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

#pragma mark - Push Photo VCs

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

#pragma mark - go showtimes

- (void)goToShowtimes:(id) sender {
    MovieFunctionsVC *vc = (MovieFunctionsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"MovieFunctionsVC"];
    vc.movieID = self.movie.movieID;
    vc.movieName = self.movie.name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MovieToCast"]) {
        CastVC *castVC = [segue destinationViewController];
        [self setPropertyValuesToCastVC:castVC];
    }
    else if ([[segue identifier] isEqualToString:@"MovieToVideos"]) {
        VideoVC *videoVC = segue.destinationViewController;
        videoVC.videos = self.movie.videos;
    }
    else if ([[segue identifier] isEqualToString:@"MovieToMovieFunctions"]) {
        MovieFunctionsVC *vc = (MovieFunctionsVC *)segue.destinationViewController;
        vc.movieID = self.movieID;
        vc.movieName = self.movieName;
    }
}

-(IBAction)goImdb:(id)sender {
    UIButton *buttonImdb = (UIButton *)sender;
    MovieCastCell *castCell = (MovieCastCell *)buttonImdb.superview.superview;
    NSIndexPath *indexPath = [self.collectionViewActors indexPathForCell: castCell];
    Person *person = (Person *)self.cast.actors[indexPath.row];
    
    NSString *actionSheetTitle = @"Abrir enlace en:";
    NSString *cancelTitle = @"Cancelar";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"App", @"Safari", nil];
    
    if ([self.openInChromeController isChromeInstalled]) {
        [actionSheet addButtonWithTitle:@"Chrome"];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"imdb:///name/%@/",person.imdbCode]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [actionSheet addButtonWithTitle:@"App Imdb"];
    }
    
    self.imdbCodeSelected = person.imdbCode;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/name/%@/",self.imdbCodeSelected];
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"App"]) {
        WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
        wvc.urlString = urlString;
        [self.navigationController pushViewController:wvc animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Safari"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if ([buttonTitle isEqualToString:@"Chrome"]) {
        if ([self.openInChromeController isChromeInstalled]) {
            [self.openInChromeController openInChrome:[NSURL URLWithString:urlString]
                                      withCallbackURL:nil
                                         createNewTab:YES];
        }
    }
    else if ([buttonTitle isEqualToString:@"App Imdb"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"imdb:///name/%@/",self.imdbCodeSelected]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Notification Observer method

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    _fontNormal = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    _fontBigBold = [UIFont getSizeForCHFont:CHFontStyleBigBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    _fontSmall = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
        
    [self.tableView reloadData];
    [self.collectionViewActors reloadData];
}

@end
