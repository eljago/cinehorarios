//
//  FunctionsVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FunctionsVC.h"
#import "FunctionDayVC.h"
#import "Theater.h"
#import "FunctionDayVC.h"

const NSInteger numberOfVCs = 7;

@interface FunctionsVC ()

@end

@implementation FunctionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:numberOfVCs];
    for (int i=0; i<numberOfVCs; i++) {
        FunctionDayVC *functionDayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FunctionDayVC"];
        functionDayVC.title = [NSString stringWithFormat:@"controller %d",i];
        functionDayVC.theaterID = self.theater.theaterID;
        functionDayVC.date = [[NSDate date] dateByAddingTimeInterval:60*60*24*(i+1)];
        [viewControllers addObject:functionDayVC];
    }
    self.viewControllers = viewControllers;
    
    __weak __typeof(self)weakSelf = self;
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        FunctionDayVC *functionDayVC = strongSelf.viewControllers[cuurentPage];
        
        [functionDayVC getDataForceDownload:NO];
    };
    
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
