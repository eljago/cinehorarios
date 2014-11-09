//
//  CastVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastVC.h"
#import "UIFont+CH.h"
#import "UIColor+CH.h"
#import "MWPhotoBrowser.h"
#import "GAI+CH.h"
#import "GlobalNavigationController.h"
#import "UIView+CH.h"
#import "CastActorCell.h"
#import "CastActorCell+Person.h"
#import "CastDirectorCell.h"
#import "CastDirectorCell+Person.h"
#import "Person.h"
#import "WebVC.h"

@interface CastVC ()

@property (nonatomic, strong) UIFont *fontName;
@property (nonatomic, strong) UIFont *fontRole;
@end

@implementation CastVC

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
    
    [GAI trackPage:@"PELICULA REPARTO"];
    
    self.fontName = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    self.fontRole = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    GlobalNavigationController *nvc = (GlobalNavigationController *)self.navigationController;
    
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
        CastDirectorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDirectors];
        Person *director = self.cast.directors[indexPath.row];
        [cell configureForPerson:director];
        
        return cell;
    }
    else {
        static NSString *CellIdentifierDirectors = @"CellActors";
        CastActorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDirectors];
        Person *actor = self.cast.actors[indexPath.row];
        [cell configureForPerson:actor];
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *text;
    if (section == 0) {
        if (self.cast.directors.count == 1) {
            text = @"Director";
        }
        else if (self.cast.directors.count > 1) {
            text = @"Directores";
        }
        else {
            text = @"";
        }
    }
    else {
        if (self.cast.actors.count > 0) {
            text = @"Reparto";
        }
        else {
            text = @"";
        }
    }
    NSInteger height = [UIView heightForHeaderViewWithText:text];
    return [UIView headerViewForText:text height:height];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.cast.directors.count == 1) {
            return @"Director";
        }
        else if (self.cast.directors.count > 1) {
            return @"Directores";
        }
        else {
            return @"";
        }
    }
    else {
        if (self.cast.actors.count > 0) {
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
        return self.cast.directors.count;
    }
    else {
        return self.cast.actors.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CastDirectorCell heightForRowWithPerson:self.cast.directors[indexPath.row] fontName:self.fontName];
    }
    else {
        return [CastActorCell heightForRowWithPerson:self.cast.actors[indexPath.row] fontName:self.fontName fontRole:self.fontRole];
    }
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        CastDirectorCell *cellDirector = (CastDirectorCell *)cell;
        cellDirector.nameLabel.font = self.fontName;
    }
    else {
        CastActorCell *cellActor = (CastActorCell *)cell;
        cellActor.nameLabel.font = self.fontName;
        cellActor.characterLabel.font = self.fontRole;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = 0;
    if (indexPath.section == 0) {
        row = indexPath.row;
    }
    else {
        row = self.cast.directors.count + indexPath.row;
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
    if (section == 0 && self.cast.directors.count == 0) {
        return 0.01;
    }
    else if (section == 1 && self.cast.actors.count == 0){
        return 0.01;
    }
    else {
        return [UIView heightForHeaderViewWithText:@"Javier"];
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
    
    self.fontName = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.fontRole = [UIFont getSizeForCHFont:CHFontStyleSmall forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    [self.tableView reloadData];
}

#pragma mark - GoImdb

-(IBAction)goImdb:(id)sender {
    UIButton *buttonImdb = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)buttonImdb.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    Person *person;
    if (indexPath.section == 0) {
        person = (Person *)self.cast.directors[indexPath.row];
    }
    else {
        person = (Person *)self.cast.actors[indexPath.row];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"AppIMDB"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"imdb:///name/%@/",person.imdbCode]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            NSURL *iTunesURL = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=342792525&mt=8"];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
    else if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"Safari"]) {
        NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/name/%@/",person.imdbCode];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
//    else if ([[userDefaults stringForKey:@"CHOpenLinksIMDB"] isEqualToString:@"InApp"]) {
    else {
        NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/name/%@/",person.imdbCode];
        WebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
        webVC.urlString = urlString;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end
