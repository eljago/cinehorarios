//
//  CHViewTableController.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHDownloadStat) {
    CHDownloadStatNone,
    CHDownloadStatNoDataFound,
    CHDownloadStatFailed,
    CHDownloadStatSuccessful
};

@interface CHViewTableController : UIViewController <UITableViewDelegate>

@end
