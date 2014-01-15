//
//  CineHorariosTableViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CineHorariosTableViewController.h"
#import "UIColor+CH.h"

@interface CineHorariosTableViewController ()
@end

@implementation CineHorariosTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor tableViewColor];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - Interface Orientation

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - CineHorariosTableViewController
#pragma mark Properties

- (DoAlertView *) alert {
    if(_alert) return _alert;
    
    _alert = [[DoAlertView alloc] init];
    _alert.nAnimationType = DoTransitionStylePop;
    _alert.dRound = 2.0;
    _alert.bDestructive = NO;
    
    return _alert;
}

#pragma mark Alerts
-(void) alertRetryWithCompleteBlock:(void (^)())completeBlock {
    [self.alert doYesNo:@"¿Reintentar?"
                    yes:^(DoAlertView *alertView) {
                        completeBlock();
                    } no:^(DoAlertView *alertView) {
                        
                    }];
    self.alert = nil;
}

@end
