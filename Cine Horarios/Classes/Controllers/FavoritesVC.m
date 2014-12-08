//
//  FavoritesViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FavoritesVC.h"
#import "FuncionesVC.h"
#import "BasicCell.h"
#import "Theater.h"
#import "BasicCell+Theater.h"
#import "UIFont+CH.h"
#import "GAI+CH.h"
#import "FunctionsContainerVC.h"

@interface FavoritesVC ()
@property (nonatomic, strong) UIFont *tableFont;
@property (nonatomic, strong) UIBarButtonItem *buttonEdit;
@end
@implementation FavoritesVC

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"FAVORITOS"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
    self.navigationItem.leftBarButtonItem = self.buttonEdit;
}

// Reload data after coming back from Theater view in case there was an edit
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadFavorites];
    
    if (self.favoriteTheaters.count == 0) {
        self.buttonEdit.enabled = NO;
    }
    else {
        self.buttonEdit.enabled = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteTheaters.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *identifier = @"Cell";
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Theater *theater = self.favoriteTheaters[indexPath.row];
    cell.mainLabel.text = theater.name;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Theater *theater = self.favoriteTheaters[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Toggle Favorite"
                                                            object:self
                                                          userInfo:@{@"TheaterName": theater.name,
                                                                     @"TheaterID": [NSNumber numberWithInteger:theater.theaterID]}];
        [self.favoriteTheaters removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.favoriteTheaters count] == 0) {
            tableView.editing = NO;
            self.buttonEdit.enabled = NO;
        }
        else {
            self.buttonEdit.enabled = YES;
        }
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    BasicCell *basicCell = (BasicCell *)cell;
    basicCell.mainLabel.font = self.tableFont;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BasicCell heightForRowWithTheater:self.favoriteTheaters[indexPath.row] tableFont:self.tableFont];
}

#pragma mark - FavoritesVC
#pragma mark Properties

- (UIFont *) tableFont {
    if(_tableFont) return _tableFont;
    
    _tableFont = [UIFont getSizeForCHFont:CHFontStyleBig forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    
    return _tableFont;
}

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
        NSError *error = nil;
        NSInteger theaterID = [NSNumber numberWithInt:[[keys objectAtIndex:i] intValue]];
        NSString *theaterName = [values objectAtIndex:i];
        NSString *theaterWebURL = [values objectat]
        NSDictionary *dict = @{@"theaterID": theaterID,
                               @"name": theaterName,
                               @"webURL": theaterWebURL};
        Theater *theater = [Theater modelWithDictionary:dict error:&error];
        [mutableTheaters insertObject:theater atIndex:i];
    }
    self.favoriteTheaters = mutableTheaters;
}

#pragma mark IBActions

- (IBAction) enterEditingMode:(UIBarButtonItem *) sender{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditingMode:)];
    }
    else{
        [self.tableView setEditing:YES animated:YES];
        self.buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditingMode:)];
    }
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    self.tableFont = [UIFont getSizeForCHFont:CHFontStyleBigger forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    FuncionesVC *functionesVC = segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Theater *theater = self.favoriteTheaters[indexPath.row];
//        FunctionsPageVC *functionsPageVC = [segue destinationViewController];
//        functionsPageVC.theaterID = theater.theaterID;
//        functionsPageVC.theaterName = theater.name;
//    functionesVC.theaterID = theater.theaterID;
//    functionesVC.theaterName = theater.name;
    FunctionsContainerVC *functionsContainerVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Theater *theater = self.favoriteTheaters[indexPath.row];
    functionsContainerVC.theater = theater;
}

@end
