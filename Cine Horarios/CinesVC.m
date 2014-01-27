//
//  CinesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinesVC.h"
#import "TheatersVC.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "BasicItem2.h"
#import "BasicItemImage.h"
#import "MTLJSONAdapter.h"
#import "RFRateMe.h"

@interface CinesVC ()
@property (nonatomic, strong) NSArray *cinemas;
@end

@implementation CinesVC {
    float _cellHeight;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"CINES" forKey:kGAIScreenName] build]];
    
    [self loadCinemas];
    
    [RFRateMe showRateAlert];
}

#pragma mark - UITableViewController
#pragma mark Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cinemas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BasicItemImage *cinema = self.cinemas[indexPath.row];
    ((UILabel *)[cell viewWithTag:101]).text = cinema.name;
    if ([cinema.imageURL isEqualToString:@""]) {
        ((UIImageView *)[cell viewWithTag:100]).image = nil;
    }
    else {
        ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:cinema.imageURL];
    }
    
    return cell;
}

#pragma mark - CinesVC
#pragma mark Fetch Data

- (void) loadCinemas {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cinemas" ofType:@"plist"];
    NSArray *cinemasLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableCinemas = [NSMutableArray array];
    for (NSDictionary *dict in cinemasLocal) {
        BasicItemImage *cinema = [MTLJSONAdapter modelOfClass:BasicItem2.class fromJSONDictionary:dict error:NULL];
        [mutableCinemas addObject:cinema];
    }
    self.cinemas = [NSArray arrayWithArray:mutableCinemas];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TheatersVC *theatersViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    BasicItemImage *cinema = self.cinemas[indexPath.row];
    theatersViewController.cinemaID = cinema.itemID;
    theatersViewController.cinemaName = cinema.name;
}

@end
