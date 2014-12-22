//
//  CHViewTableController_Protected.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHViewTableController.h"

@interface CHViewTableController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) UIFont *fontBody;
@property (nonatomic, strong, readonly) UIFont *fontHeadline;
@property (nonatomic, strong, readonly) UIFont *fontFootnote;

- (void) refreshData;
- (void) downloadEndedWithDownloadStatus: (CHDownloadStat) downloadStatus;
@end
