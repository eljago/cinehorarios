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

@interface MovieFunctionsVC ()
@property (nonatomic, strong) NSArray *functions;
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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getMovieFunctionsForceRemote:NO];
}
- (void) getMovieFunctionsForceRemote:(BOOL) forceRemote {
    
    if (forceRemote) {
        [self downloadMovieFunctions];
    }
    else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",[components year], [components month], [components day]];
        NSArray *functions = [Function getLocalMovieFunctionsWithMovieID:self.movieID theaterID:self.theaterID dateString:dateString];
        if (functions.count) {
            self.functions = functions;
            [self.tableView reloadData];
        }
        else {
            [self downloadMovieFunctions];
        }
    }
}
-(void) downloadMovieFunctions{
    self.tableView.scrollEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Function getMovieFunctionsWithBlock:^(NSArray *functions, NSError *error)  {
        if (!error) {
            self.functions = functions;
            [self.tableView reloadData];
        }
        else {
            [self showAlert];
        }
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    } movieID:self.movieID theaterID:self.theaterID date:[NSDate new]];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self getMovieFunctionsForceRemote:YES];
}
- (void) showAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Problema en la Descarga" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reintentar", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self getMovieFunctionsForceRemote:YES];
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

-
(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Function *function = self.functions[indexPath.row];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.functions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Function *function = self.functions[indexPath.row];
    UILabel *functionTypes = (UILabel *)[cell viewWithTag:1];
    UILabel *functionShowtimes = (UILabel *)[cell viewWithTag:2];
    functionTypes.text = function.types;
    functionShowtimes.text = function.showtimes;
    functionTypes.font = tableFont;
    functionShowtimes.font = tableFont;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderView];
}
-(CGFloat) heightForHeaderView {
    CGSize size = CGSizeMake(310.f, 1000.f);
    
    CGRect nameLabelRect = [self.movieName boundingRectWithSize: size
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, [self heightForHeaderView])];
    view.backgroundColor = [UIColor tableViewColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, [self heightForHeaderView])];
    label.numberOfLines = 0;
    label.tag = 40;
    label.font = headerFont;
    label.text = self.movieName;
    [view addSubview: label];
    return view;
}

@end
