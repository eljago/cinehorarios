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

@interface CloseTheatersVC () <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *myMap;
@property BOOL userLocationUpdated;
@property (nonatomic, strong) NSArray *annotations;
@end

@implementation CloseTheatersVC

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
    self.myMap.showsUserLocation = YES;
//    [self.myMap setCenterCoordinate:self.myMap.userLocation.location.coordinate animated:YES];
    
//    CLLocationCoordinate2D startCenter = CLLocationCoordinate2DMake(-33.440467, -70.621617);
//
    
    [AnnotationTheater getAnnotationsWithBlock:^(NSArray *annotations, NSError *error) {
        self.annotations = annotations;

        [self.myMap addAnnotations: self.annotations];
        [self.myMap setCenterCoordinate: self.myMap.userLocation.location.coordinate animated:YES];
        CLLocationDistance regionWidth = 4500;
        CLLocationDistance regionHeight = 4500;
        MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(self.myMap.userLocation.location.coordinate, regionWidth, regionHeight);
        [self.myMap setRegion:startRegion animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.userLocationUpdated) {
        [self.myMap setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.userLocationUpdated = YES;
    }
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

@end
