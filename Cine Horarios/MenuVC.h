//
//  MenuVC.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVC : UIViewController
@property (nonatomic, strong) NSString *startingVCID;
-(void)selectRowWithStoryboardID:(NSString *)identifier;

@end
