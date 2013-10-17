//
//  MovieFunctionsTheatersViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieTheatersVC.h"
#import "MovieFunctionsVC.h"
#import "BasicItem.h"
#import "Theater.h"
#import "Movie.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface MovieTheatersVC ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MovieTheatersVC {
    UIFont *headerFont;
    UIFont *tableFont;
}

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
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA COMPLEJOS" forKey:kGAIScreenName] build]];
    
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.theaters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Theater *theater = self.theaters[indexPath.row];
    cell.textLabel.text = theater.name;
    cell.textLabel.font = tableFont;
    
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

#pragma mark - content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    headerFont = [UIFont getSizeForCHFont:CHFontStyleSmallBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    tableFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		MovieFunctionsVC *vc = segue.destinationViewController;
        vc.movieID = self.movieID;
        vc.movieName = self.movieName;
        vc.theaterID = ((Theater *)self.theaters[indexPath.row]).itemId;
        vc.title = ((Theater *)self.theaters[indexPath.row]).name;
}
@end
