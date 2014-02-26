//
//  CloseTheatersVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-11-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CloseTheatersVC.h"
#import <MapKit/MapKit.h>
#import "AnnotationGroup.h"
#import "AnnotationTheater.h"
#import "MBProgressHUD.h"
#import "UIColor+CH.h"
#import "GAI+CH.h"
#import "FuncionesVC.h"
#import "DoAlertView.h"
#import "UIViewController+DoAlertView.h"

NSInteger const kMaxTheaterDistance = 26000;
NSInteger const kRegionSize = 4000;
NSInteger const kRegionZoomedSize = 1000;
NSInteger const kMaxNumberOfCloseTheaters = 3;

@interface CloseTheatersVC () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *myMap;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *myMapBottomSpaceToBotomLayout;
@property (nonatomic, weak) IBOutlet UIButton *buttonToggleTable;
@property BOOL userLocationUpdated;
@property (nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) UIBarButtonItem *buttonCenterUser;
@property (nonatomic, strong) UIBarButtonItem *buttonReload;
@end

@implementation CloseTheatersVC

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"MAPA"];
    
    self.myMap.showsUserLocation = YES;
    
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    self.buttonCenterUser = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MapsCenterUser"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(centerUser:)];
    
    self.buttonReload = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"WebReload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    
    
    self.navigationItem.leftBarButtonItems = @[self.buttonCenterUser, self.buttonReload];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
//    [self getTheatersLocationsForceRemote:NO];
    
    if (!self.annotations) {
        [self disableBarButtonItems];
        self.buttonToggleTable.enabled = NO;
    }
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.userLocationUpdated) {
//        [self.myMap setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.userLocationUpdated = YES;
        
        CLLocationDistance regionWidth = kRegionSize;
        CLLocationDistance regionHeight = kRegionSize;
        MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(self.myMap.userLocation.location.coordinate, regionWidth, regionHeight);
        [self.myMap setRegion:startRegion animated:NO];
        
        [self getTheatersLocationsForceRemote:NO];
    }
    
    [self setDistances];
    [self.tableView reloadData];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"annoView";
    MKAnnotationView *view = [self.myMap dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        UIButton *rightCalloutAV = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightCalloutAV.tintColor = [UIColor grayColor];
        [rightCalloutAV setImage:[[UIImage imageNamed:@"WebForward"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        rightCalloutAV.frame = CGRectMake(0, 0, 32, 32);
        view.rightCalloutAccessoryView = rightCalloutAV;
    }
    AnnotationTheater *annotationTheater = (AnnotationTheater *)annotation;
    switch (annotationTheater.cinemaID) {
        case 1:
            view.image = [UIImage imageNamed:@"AnnotationCinemark"];
            break;
        case 2:
            view.image = [UIImage imageNamed:@"AnnotationCineHoyts"];
            break;
        case 3:
            view.image = [UIImage imageNamed:@"AnnotationCineplanet"];
            break;
        case 4:
            view.image = [UIImage imageNamed:@"AnnotationCinemundo"];
            break;
        case 5:
            switch (annotationTheater.theaterID) {
                case 47:
                    view.image = [UIImage imageNamed:@"AnnotationNormandie"];
                    break;
                case 46:
                    view.image = [UIImage imageNamed:@"AnnotationArteAlameda"];
                    break;
                case 51:
                    view.image = [UIImage imageNamed:@"AnnotationElBiografo"];
                    break;
                    
                default:
                    break;
            }
//            view.image = [UIImage imageNamed:@"AnnotationCinesIndependientes"];
            break;
        case 6:
            view.image = [UIImage imageNamed:@"AnnotationCinePavilion"];
            break;
        case 7:
            view.image = [UIImage imageNamed:@"AnnotationCineStar"];
            break;
            
        default:
            break;
    }
    view.canShowCallout = YES;
    
    return view;
}
-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {

    if (error.userInfo[@"NSLocalizedRecoverySuggestion"]) {
        DoAlertView *alert = [[DoAlertView alloc] init];
        alert.nAnimationType = DoTransitionStylePop;
        alert.dRound = 2.0;
        alert.bDestructive = NO;
        [alert doYes:error.userInfo[@"NSLocalizedRecoverySuggestion"] yes:^(DoAlertView *alertView) {
            
        }];
    }
}

//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    CLLocationCoordinate2D coordinate = view.annotation.coordinate;
//    [self zoomMapAtCoordinate:coordinate];
//}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    FuncionesVC *functionesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FuncionesVC"];
    AnnotationTheater *annotation = view.annotation;
    functionesVC.theaterName = annotation.title;
    functionesVC.theaterID = annotation.theaterID;
    
    [self.navigationController pushViewController:functionesVC animated:YES];
}

#pragma mark - UITableView
#pragma mark Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.annotations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    AnnotationTheater *annotation = self.annotations[indexPath.row];
    cell.textLabel.text = annotation.title;
    double distance = annotation.distance/1000;
    NSString *distanceString = [NSString stringWithFormat:@"%.2lf km.",distance];
    if (distance < 1) {
        distanceString = [NSString stringWithFormat:@"%d m.",(int)(distance*1000)];
    }
    cell.detailTextLabel.text = distanceString;
    
    switch (annotation.cinemaID) {
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"LogoCinemark"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"LogoCineHoyts"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"LogoCineplanet"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"LogoCinemundo"];
            break;
        case 5:
            switch (annotation.theaterID) {
                case 47:
                    cell.imageView.image = [UIImage imageNamed:@"LogoNormandie"];
                    break;
                case 46:
                    cell.imageView.image = [UIImage imageNamed:@"LogoArteAlameda"];
                    break;
                case 51:
                    cell.imageView.image = [UIImage imageNamed:@"LogoElBiografo"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 6:
            cell.imageView.image = [UIImage imageNamed:@"LogoCinePavilion"];
            break;
        case 7:
            cell.imageView.image = [UIImage imageNamed:@"LogoCineStar"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocationCoordinate2D coordinate = [self.annotations[indexPath.row] coordinate];
    [self zoomMapAtCoordinate:coordinate];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FuncionesVC *functionesVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    AnnotationTheater *annotation = self.annotations[indexPath.row];
    functionesVC.theaterName = annotation.title;
    functionesVC.theaterID = annotation.theaterID;
}

#pragma mark - CloseTheatersVC

- (void) createAnnotationsWithAnnotationGroup:(AnnotationGroup *)annotationGroup {
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in annotationGroup.annotationTheaters) {
        AnnotationTheater *annotation = [[AnnotationTheater alloc] initWithDictionary:dictionary];
        if (annotation.coordinate.latitude != 0 && annotation.coordinate.longitude != 0) {
            [mutaArray addObject:annotation];
        }
    }
    self.annotations = mutaArray;
}
#pragma mark Fetch Data
- (void) getTheatersLocationsForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadTheatersLocations];
    }
    else {
        [self disableBarButtonItems];
        if (!self.annotations && self.annotations.count == 0) {
            AnnotationGroup *annotationGroup = [AnnotationGroup loadAnnotationGroup];
            [self createAnnotationsWithAnnotationGroup:annotationGroup];
        }
        
        if (self.annotations && self.annotations.count) {
            [self processAnnotationsGenerateRegionAndEnableButtons];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else {
            [self downloadTheatersLocations];
        }
    }
}
- (void) downloadTheatersLocations {
    [self disableBarButtonItems];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnnotationGroup getAnnotationsWithBlock:^(AnnotationGroup *annotationGroup, NSError *error) {
        if (!error) {
            [self createAnnotationsWithAnnotationGroup:annotationGroup];
            if (self.annotations && self.annotations.count) {
                [self processAnnotationsGenerateRegionAndEnableButtons];
            }
        }
        else {
            [self enableBarButtonItems];
            [self alertRetryWithCompleteBlock:^{
                [self getTheatersLocationsForceRemote:YES];
            }];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void) processAnnotationsGenerateRegionAndEnableButtons {
    [self setDistances];
    [self.annotations sortUsingSelector:@selector(compareAnnotationsDistance:)];
    [self.myMap addAnnotations:self.annotations];
    
    [self calculateRegion];
    [self.myMap setRegion:self.region animated:YES];
    [self.tableView reloadData];
    
    [self enableBarButtonItems];
    self.buttonToggleTable.enabled = YES;
}

#pragma mark Other Shit

-(void)zoomMapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocationDistance regionWidth = kRegionZoomedSize;
    CLLocationDistance regionHeight = kRegionZoomedSize;
    MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionWidth, regionHeight);
    [self.myMap setRegion:startRegion animated:YES];
}

- (IBAction)toggleTheatersTable:(id)sender {
    CGFloat toHeight;
    if (self.myMapBottomSpaceToBotomLayout.constant == self.view.bounds.size.height/2) {
        toHeight = 0;
        [self.buttonToggleTable setImage:[UIImage imageNamed:@"MapsShowTable"] forState:UIControlStateNormal];
    }
    else {
        toHeight = self.view.bounds.size.height/2;
        [self.buttonToggleTable setImage:[UIImage imageNamed:@"MapsHideTable"] forState:UIControlStateNormal];
    }
    self.myMapBottomSpaceToBotomLayout.constant = toHeight;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void) calculateRegion {
    
    NSMutableArray *lats = [[NSMutableArray alloc] init];
    NSMutableArray *lngs = [[NSMutableArray alloc] init];
    [lats addObject:[NSNumber numberWithDouble:self.myMap.userLocation.location.coordinate.latitude]];
    [lngs addObject:[NSNumber numberWithDouble:self.myMap.userLocation.location.coordinate.longitude]];

    AnnotationTheater *closestAnnotation = [self.annotations firstObject];
    [lats addObject:[NSNumber numberWithDouble:closestAnnotation.coordinate.latitude]];
    [lngs addObject:[NSNumber numberWithDouble:closestAnnotation.coordinate.longitude]];
    
    NSArray *closestAnnotationsExceptFirstOne = [self.annotations objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,kMaxNumberOfCloseTheaters)]];
    for (AnnotationTheater *annotation in closestAnnotationsExceptFirstOne) {
        if (annotation.distance < kMaxTheaterDistance) {
            [lats addObject:[NSNumber numberWithDouble:annotation.coordinate.latitude]];
            [lngs addObject:[NSNumber numberWithDouble:annotation.coordinate.longitude]];
        }
    }
    [lats sortUsingSelector:@selector(compare:)];
    [lngs sortUsingSelector:@selector(compare:)];
    
    double smallestLat = [[lats firstObject] doubleValue];
    double smallestLng = [[lngs firstObject] doubleValue];
    double biggestLat = [[lats lastObject] doubleValue];
    double biggestLng = [[lngs lastObject] doubleValue];
    
    CLLocationCoordinate2D annotationsCenter = CLLocationCoordinate2DMake((biggestLat + smallestLat)/2, (biggestLng + smallestLng)/2);
    MKCoordinateSpan annotationsSpan = MKCoordinateSpanMake(biggestLat - smallestLat + 0.025, biggestLng - smallestLng + 0.025);
    self.region = MKCoordinateRegionMake(annotationsCenter, annotationsSpan);
}
- (IBAction)reloadRegion:(id)sender {
    if (self.annotations.count) {
        [self.myMap setRegion:self.region animated:YES];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
- (IBAction)centerUser:(id)sender {
    CLLocationDistance regionWidth = kRegionZoomedSize;
    CLLocationDistance regionHeight = kRegionZoomedSize;
    MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(self.myMap.userLocation.location.coordinate, regionWidth, regionHeight);
    [self.myMap setRegion:startRegion animated:YES];
    if (self.annotations.count) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void)reload{
    [self getTheatersLocationsForceRemote:NO];
}
- (void) setDistances {
    for (AnnotationTheater *annotation in self.annotations) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        double distance = [location distanceFromLocation:self.myMap.userLocation.location];
        annotation.distance = distance;
    }
}
-(void) disableBarButtonItems {
    [self.buttonCenterUser setEnabled:NO];
    [self.buttonReload setEnabled:NO];
}
-(void) enableBarButtonItems {
    [self.buttonCenterUser setEnabled:YES];
    [self.buttonReload setEnabled:YES];
}

//#pragma mark Fetch Data
//
//- (void) getMovieForceRemote:(BOOL) forceRemote {
//    if (forceRemote) {
//        [self downloadMovie];
//    }
//    else {
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            self.movie = [Movie getLocalMovieWithMovieID:self.movieID];
//            dispatch_async(dispatch_get_main_queue(), ^ {
//                if (self.movie) {
//                    [self setupTableViews];
//                }
//                else {
//                    [self downloadMovie];
//                }
//            });
//        });
//    }
//}

#pragma mark - Interface Orientation

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
