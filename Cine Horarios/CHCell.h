//
//  CHCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 05-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasicItem;

@interface CHCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) BasicItem *basicItem;

+ (CGFloat)heightForCellWithBasicItem:(BasicItem *)basicItem withFont:(UIFont *)font;
-(void)setFont:(UIFont *)font;
@end
