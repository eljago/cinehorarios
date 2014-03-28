//
//  MovieRowOneCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-03-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;
@class MyMultilineLabel;

@interface MovieRowOneCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *portraitImageView;
@property (nonatomic, strong) MyMultilineLabel *labelName;
@property (nonatomic, strong) MyMultilineLabel *labelNameOriginal;
@property (nonatomic, strong) MyMultilineLabel *labelDurationGenres;
@property (nonatomic, strong) UIView *viewOverPortrait;

@property (nonatomic, weak) IBOutlet UIImageView *coverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *coverImageViewShadow;
@property (nonatomic, weak) IBOutlet UITextView *textViewSynopsis;

@end
