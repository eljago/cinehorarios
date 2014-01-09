//
//  CastVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastVC.h"
#import "DirectorCell.h"
#import "ActorCell.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MWPhotoBrowser.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GlobalNavigationController.h"
#import "UIView+CH.h"

@interface CastVC ()

@end

@implementation CastVC {
    UIFont *fontName;
    UIFont *fontRole;
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
	// Do any additional setup after loading the view.
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA REPARTO" forKey:kGAIScreenName] build]];
    
    fontName = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    fontRole = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    GlobalNavigationController *nvc = (GlobalNavigationController *)self.navigationController;
    nvc.transitionPanGesture.enabled = YES;
    
    [nvc.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifierDirectors = @"CellDirectors";
        DirectorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDirectors];
        
        cell.actor = self.directors[indexPath.row];
        cell.labelName.font = fontName;
        
        return cell;
    }
    else {
        static NSString *CellIdentifierDirectors = @"CellActors";
        ActorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDirectors];
        
        Actor *actor = self.actors[indexPath.row];
        cell.actor = actor;
        cell.labelName.font = fontName;
        cell.labelRole.font = fontRole;
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *text;
    if (section == 0) {
        if (self.directors.count == 1) {
            text = @"Director";
        }
        else if (self.directors.count > 1) {
            text = @"Directores";
        }
        else {
            text = @"";
        }
    }
    else {
        if (self.actors.count > 0) {
            text = @"Reparto";
        }
        else {
            text = @"";
        }
    }
    NSInteger height = [UIView heightForHeaderViewWithText:text font:fontName];
    return [UIView headerViewForText:text font:fontName height:height];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.directors.count == 1) {
            return @"Director";
        }
        else if (self.directors.count > 1) {
            return @"Directores";
        }
        else {
            return @"";
        }
    }
    else {
        if (self.actors.count > 0) {
            return @"Reparto";
        }
        else {
            return @"";
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.directors.count;
    }
    else {
        return self.actors.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [DirectorCell heightForCellWithActor:self.directors[indexPath.row] withFont:fontName];
    }
    else {
        return [ActorCell heightForCellWithActor:self.actors[indexPath.row] withNameFont:fontName roleFont:fontRole];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GlobalNavigationController *nvc = (GlobalNavigationController *)self.navigationController;
    nvc.transitionPanGesture.enabled = NO;
    
    NSUInteger row = 0;
    if (indexPath.section == 0) {
        row = indexPath.row;
    }
    else {
        row = self.directors.count + indexPath.row;
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.zoomPhotosToFill = NO;
    [browser setCurrentPhotoIndex:row];
    
    [self.navigationController pushViewController:browser animated:YES];
    
}

#pragma mark Row & Height Calculators

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.directors.count == 0) {
        return 0.01;
    }
    else if (section == 1 && self.actors.count == 0){
        return 0.01;
    }
    else {
        return [UIView heightForHeaderViewWithText:@"Javier" font:fontName];
    }
}

#pragma mark - Photo Browser Delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    
    fontName = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    fontRole = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

@end
