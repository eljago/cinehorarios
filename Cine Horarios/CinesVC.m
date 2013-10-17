//
//  CinesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 15-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CinesVC.h"
#import "TheatersVC.h"
#import "BasicImageItem.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface CinesVC ()
@property (nonatomic, strong) NSArray *cinemas;
@end

@implementation CinesVC {
    float _cellHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"CINES" forKey:kGAIScreenName] build]];
    
    [self loadCinemas];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadCinemas {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cinemas" ofType:@"plist"];
    NSArray *cinemasLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableCinemas = [NSMutableArray array];
    for (NSDictionary *dict in cinemasLocal) {
        [mutableCinemas addObject:[[BasicImageItem alloc] initWithId:[dict[@"id"] integerValue] name:dict[@"name"] imageUrl:dict[@"image"]]];
    }
    self.cinemas = [NSArray arrayWithArray:mutableCinemas];
}

#pragma mark - Table View Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cinemas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BasicImageItem *cinema = self.cinemas[indexPath.row];
    ((UILabel *)[cell viewWithTag:101]).text = cinema.name;
    ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:cinema.imageUrl];
    
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TheatersVC *theatersViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    BasicImageItem *cinema = self.cinemas[indexPath.row];
    theatersViewController.cinemaID = cinema.itemId;
    theatersViewController.cinemaName = cinema.name;
}

@end
