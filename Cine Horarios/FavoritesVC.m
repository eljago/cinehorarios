//
//  FavoritesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FavoritesVC.h"
#import "BasicItem.h"
#import "FuncionesVC.h"
#import "UIColor+CH.h"
#import "CHCell.h"
#import "UIFont+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation FavoritesVC {
    UIFont *tableFont;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"FAVORITOS" forKey:kGAIScreenName] build]];
    
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
}

// Reload data after coming back from Theater view in case there was an edit
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadFavorites];
    
    if ([self.favoriteTheaters count] == 0) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewController
#pragma mark Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favoriteTheaters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CHCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BasicItem *theater = self.favoriteTheaters[indexPath.row];
    cell.basicItem = theater;
    [cell setFont:tableFont];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BasicItem *theater = self.favoriteTheaters[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Toggle Favorite"
                                                            object:self
                                                          userInfo:@{@"TheaterName": theater.name,
                                                                     @"TheaterID": [NSNumber numberWithInteger:theater.itemId]}];
        [self.favoriteTheaters removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.favoriteTheaters count] == 0) {
            tableView.editing = NO;
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
        else {
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
    }
}

#pragma mark Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CHCell heightForCellWithBasicItem:self.favoriteTheaters[indexPath.row] withFont:tableFont];
}

#pragma mark - FavoritesVC
#pragma mark Fetch Data

- (void) loadFavorites{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icloud.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"icloud" ofType:@"plist"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *favorites = [dict valueForKey:@"Favorites"];
    NSMutableArray *mutableTheaters = [[NSMutableArray alloc] initWithCapacity:[favorites count]];
    NSArray *keys = [favorites allKeys];
    NSArray *values = [favorites allValues];
    for (int i=0;i<[favorites count];i++){
        BasicItem *theater = [[BasicItem alloc] initWithId:[[keys objectAtIndex:i] integerValue] name:[values objectAtIndex:i]];
        [mutableTheaters insertObject:theater atIndex:i];
    }
    self.favoriteTheaters = mutableTheaters;
}

#pragma mark IBActions

- (IBAction) enterEditingMode:(UIBarButtonItem *) sender{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
    }
    else{
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditingMode:)];
    }
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FuncionesVC *functionesVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    BasicItem *theater = self.favoriteTheaters[indexPath.row];
    functionesVC.theaterID = theater.itemId;
    functionesVC.theaterName = theater.name;
    
}

@end
