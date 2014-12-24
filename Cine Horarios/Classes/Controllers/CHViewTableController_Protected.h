//
//  CHViewTableController_Protected.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"

@interface CHViewTableController ()
@property (nonatomic, strong, readonly) UIFont *fontBody;
@property (nonatomic, strong, readonly) UIFont *fontHeadline;
@property (nonatomic, strong, readonly) UIFont *fontFootnote;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void) refreshData;
- (void) downloadEndedWithDownloadStatus: (CHDownloadStat) downloadStatus;
@end
