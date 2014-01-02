//
//  CloseTheatersVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-11-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CloseTheatersVC.h"
#import <MapKit/MapKit.h>
#import "AnnotationTheater.h"
#import "MBProgressHUD.h"

@interface CloseTheatersVC () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *myMap;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *myMapHeightConstraint;
@property (nonatomic, weak) UIButton *buttonShowTable;
@property (nonatomic, weak) UIButton *buttoncenterUser;
@property BOOL userLocationUpdated;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) MKCoordinateRegion region;
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
	// Do any additional setup after loading the view.
    self.myMapHeightConstraint.constant = self.view.bounds.size.height;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    [self createBarMapButtons];
    
    self.myMap.showsUserLocation = YES;
    
    [self getTheatersLocationsForceRemove:NO];
}

- (void) setDistances {
    for (AnnotationTheater *annotation in self.annotations) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        double distance = [location distanceFromLocation:self.myMap.userLocation.location];
        annotation.distance = distance;
    }
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.userLocationUpdated) {
//        [self.myMap setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.userLocationUpdated = YES;
        
        CLLocationDistance regionWidth = 4000;
        CLLocationDistance regionHeight = 4000;
        MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(self.myMap.userLocation.location.coordinate, regionWidth, regionHeight);
        [self.myMap setRegion:startRegion animated:NO];
        

    }
}

- (void) getTheatersLocationsForceRemove:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadTheatersLocations];
    }
    else {
        self.annotations = [AnnotationTheater getLocalAnnotations];
        if (self.annotations.count) {
            [self.tableview reloadData];
        }
        else {
            [self downloadTheatersLocations];
        }
    }
}
- (void) downloadTheatersLocations {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnnotationTheater getAnnotationsWithBlock:^(NSMutableArray *annotations, NSError *error) {
        
        if (!error) {
            self.annotations = annotations;
            
            [self setDistances];
            [self.annotations sortUsingSelector:@selector(compareAnnotationsDistance:)];
            [self.myMap addAnnotations: self.annotations];
            
            [self calculateRegion];
            [self.myMap setRegion:self.region animated:YES];
            [self.tableview reloadData];
        }
        else {
            [self showAlert];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)refreshData {
    [self getTheatersLocationsForceRemove:YES];
}
- (void) showAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Problema en la Descarga" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reintentar", nil];
    [alertView show];
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
        rightCalloutAV.tintColor = [UIColor blackColor];
        rightCalloutAV.frame = CGRectMake(0, 0, 32, 32);
        view.rightCalloutAccessoryView = rightCalloutAV;
    }
    switch (((AnnotationTheater *)annotation).cinemaID) {
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
            view.image = [UIImage imageNamed:@"AnnotationCinesIndependientes"];
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

#pragma mark - UITableView
#pragma mark Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.annotations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    AnnotationTheater *annotation = self.annotations[indexPath.row];
    cell.textLabel.text = annotation.name;
    double distance = [self.annotations[indexPath.row] distance]/1000;
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
//            cell.imageView.image = [UIImage imageNamed:@"LogoCinesIndependientes"];
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
    CLLocationDistance regionWidth = 1000;
    CLLocationDistance regionHeight = 1000;
    MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionWidth, regionHeight);
    [self.myMap setRegion:startRegion animated:YES];
}

#pragma mark - CloseTheatersVC
- (IBAction)toggleTheatersTable:(id)sender {
    CGFloat toHeight;
    if (self.myMapHeightConstraint.constant == self.view.bounds.size.height/2) {
        toHeight = self.view.bounds.size.height;
        [self.navigationItem.leftBarButtonItems[0] setImage:[UIImage imageNamed:@"MapsShowTable"]];
    }
    else {
        toHeight = self.view.bounds.size.height/2;
        [self.navigationItem.leftBarButtonItems[0] setImage:[UIImage imageNamed:@"MapsHideTable"]];
    }
    self.myMapHeightConstraint.constant = toHeight;
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
    
    NSArray *closestAnnotationsExceptFirstOne = [self.annotations objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,4)]];
    for (AnnotationTheater *annotation in closestAnnotationsExceptFirstOne) {
        if (annotation.distance < 26000) {
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
    self.buttoncenterUser.enabled = YES;
}
- (IBAction)reloadRegion:(id)sender {
    [self.myMap setRegion:self.region animated:YES];
}
- (IBAction)centerUser:(id)sender {
    CLLocationDistance regionWidth = 1000;
    CLLocationDistance regionHeight = 1000;
    MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(self.myMap.userLocation.location.coordinate, regionWidth, regionHeight);
    [self.myMap setRegion:startRegion animated:YES];
}

#pragma mark - Create LeftBarButtonItems
- (void) createBarMapButtons {
    UIBarButtonItem *buttonCenterUser = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MapsCenterUser"] style:UIBarButtonItemStylePlain target:self action:@selector(centerUser:)];
    UIBarButtonItem *buttonShowTable = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MapsShowTable"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleTheatersTable:)];
    UIBarButtonItem *buttonReloadRegion = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebReload"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadRegion:)];
    self.navigationItem.leftBarButtonItems = @[buttonShowTable, buttonCenterUser, buttonReloadRegion];
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
