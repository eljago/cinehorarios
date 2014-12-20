//
//  FunctionsPageVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 07-11-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHDownloadStatus) {
    CHDownloadStatusNotDownloaded,
    CHDownloadStatusFailedDownload,
    CHDownloadStatusDownloadSuccessful
};

@class FunctionsContainerVC, FuncionesVC;

@interface FunctionsPageVC : UIPageViewController

@property (nonatomic, strong) UIFont *headFont;
@property (nonatomic, strong) UIFont *bodyFont;
@property (nonatomic, strong) UIFont *showtimesFont;

@property (nonatomic, strong) NSString *theaterName;
@property (nonatomic, assign) NSUInteger theaterID;
@property (nonatomic, assign) NSUInteger cinemaID;

@property (nonatomic, strong) FunctionsContainerVC *functionsContainerVC;

- (CHDownloadStatus) getDownloadStatusForIndex:(NSInteger)index;
- (void) setDownloadStatus:(CHDownloadStatus)downloadStatus atIndex:(NSInteger)index;
- (FuncionesVC *) getCurrentFuncionesVC;

@end
