//
//  MovieFunctionsShowtimesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 03-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieFunctionsVC.h"
#import "MBProgressHUD.h"
#import "Theater.h"
#import "Movie.h"
#import "Function.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "TheaterFunctions.h"

@interface MovieFunctionsVC ()
@property (nonatomic, strong) NSArray *theaterFuctions;
@end

@implementation MovieFunctionsVC {
    UIFont *headerFont;
    UIFont *tableFont;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA FUNCIONES" forKey:kGAIScreenName] build]];
    
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.sideMenuViewController action:@selector(presentMenuViewController)];
    
    [self downloadMovieFunctions];
}
-(void) downloadMovieFunctions{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TheaterFunctions getMovieTheatersFavoritesWithBlock:^(NSArray *theaterFunctions, NSError *error) {
        if (!error) {
            self.theaterFuctions = theaterFunctions;
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
        }
        else {
            [self showAlert];
        }
    } movieID:self.movieID theaters:self.theaters];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void) showAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Problema en la Descarga" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reintentar", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self downloadMovieFunctions];
    }
}

#pragma mark - Content Size Changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TheaterFunctions *theater = self.theaterFuctions[indexPath.section];
    Function *function = theater.functions[indexPath.row];
    CGSize size = CGSizeMake(280.f, 1000.f);
    
    CGRect typesLabelRect = [function.types boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:tableFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect showtimesLabelRect = [function.showtimes boundingRectWithSize: size
                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                              attributes: [NSDictionary dictionaryWithObject:tableFont forKey:NSFontAttributeName]
                                                                 context: nil];
    
    CGFloat totalHeight = 10.0f + typesLabelRect.size.height + 5.0f + showtimesLabelRect.size.height + 10.0f;
    
    return totalHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.theaterFuctions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TheaterFunctions *theater = self.theaterFuctions[section];
    return theater.functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TheaterFunctions *theater = self.theaterFuctions[indexPath.section];
    Function *function = theater.functions[indexPath.row];
    
    UILabel *functionTypes = (UILabel *)[cell viewWithTag:1];
    UILabel *functionShowtimes = (UILabel *)[cell viewWithTag:2];
    functionTypes.text = function.types;
    functionShowtimes.text = function.showtimes;
    functionTypes.font = tableFont;
    functionShowtimes.font = tableFont;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(310.f, 1000.f);
    
    TheaterFunctions *theater = self.theaterFuctions[section];
    CGRect nameLabelRect = [theater.name  boundingRectWithSize: size
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: [NSDictionary dictionaryWithObject:headerFont
                                                                                            forKey:NSFontAttributeName]
                                                       context: nil];
    
    CGFloat totalHeight = 5.0f + nameLabelRect.size.height + 8.0f;
    
    if (totalHeight <= 25.f) {
        totalHeight = 25.f;
    }
    
    return totalHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger height = [self tableView:self.tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, height)];
    view.backgroundColor = [UIColor tableViewColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, height)];
    label.numberOfLines = 0;
    label.tag = 40;
    label.font = headerFont;
    TheaterFunctions *theater = self.theaterFuctions[section];
    label.text = theater.name;
    [view addSubview: label];
    return view;
}

@end
