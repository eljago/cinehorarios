//
//  CastVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CastVC.h"
#import "CHViewTableController_Protected.h"
#import "GlobalNavigationController.h"
#import "Person.h"
#import "WebVC.h"
#import "Cast.h"
#import "GAI+CH.h"
#import "UIViewController+WebOpener.h"

#import "MWPhotoBrowser.h"

#import "UIView+CH.h"
#import "CastActorCell.h"
#import "CastActorCell+Person.h"
#import "CastDirectorCell.h"
#import "CastDirectorCell+Person.h"

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
        return [CastDirectorCell heightForRowWithPerson:self.cast.directors[indexPath.row] fontName:self.fontNormal];
    }
    else {
        return [CastActorCell heightForRowWithPerson:self.cast.actors[indexPath.row] fontName:self.fontNormal fontRole:self.fontSmall];
    }
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        CastDirectorCell *cellDirector = (CastDirectorCell *)cell;
        cellDirector.nameLabel.font = self.fontNormal;
    }
    else {
        CastActorCell *cellActor = (CastActorCell *)cell;
        cellActor.nameLabel.font = self.fontNormal;
        cellActor.characterLabel.font = self.fontSmall;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
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
        return [UIView heightForHeaderViewWithText:@"Arturo"];
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.imdb.com/name/%@/",person.imdbCode];
    NSString *appUrlString = [NSString stringWithFormat:@"imdb:///name/%@/",person.imdbCode];
    [self goWebPageWithUrlString:urlString imdbAppUrlString:appUrlString];
}

@end
