//
//  CHViewTableController_Protected.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"

@interface CHViewTableController ()
@property (nonatomic, strong, readonly) UIFont *fontNormal;
@property (nonatomic, strong, readonly) UIFont *fontBigBold;
@property (nonatomic, strong, readonly) UIFont *fontSmall;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;

- (void) refreshData;
- (void) downloadEndedWithDownloadStatus: (CHDownloadStat) downloadStatus;
@end
