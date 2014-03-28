//
//  MovieRowOneCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-03-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieRowOneCell.h"
#import "MyMultilineLabel.h"
#import "Movie.h"
#import "UIImageView+CH.h"

@interface MovieRowOneCell ()

@end

@implementation MovieRowOneCell

- (void)awakeFromNib
{
    // Initialization code
    
    UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 85, 30)];
    self.textViewSynopsis.textContainer.exclusionPaths = @[exclusionPath];
    
    self.viewOverPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.viewOverPortrait.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.labelName = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelName.textColor = [UIColor whiteColor];
    self.labelNameOriginal = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelNameOriginal.textColor = [UIColor whiteColor];
    self.labelDurationGenres = [[MyMultilineLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.labelDurationGenres.textColor = [UIColor whiteColor];
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.5] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    
    NSDictionary *viewsDictionary = @{
                                      @"portraitImageView": self.portraitImageView,
                                      @"name": self.labelName,
                                      @"nameOriginal": self.labelNameOriginal,
                                      @"durationGenres": self.labelDurationGenres,
                                      @"viewOverPortrait": self.viewOverPortrait,
                                      @"gradientView": gradientView
                                      };
    for (UIView *view in [viewsDictionary allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.portraitImageView.superview addSubview:self.viewOverPortrait];
    [self.portraitImageView.superview addSubview:gradientView];
    [self.viewOverPortrait addSubview:self.labelName];
    [self.viewOverPortrait addSubview:self.labelNameOriginal];
    [self.viewOverPortrait addSubview:self.labelDurationGenres];
    
    [self.portraitImageView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewOverPortrait]|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:viewsDictionary]];
    [self.portraitImageView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[gradientView]|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:viewsDictionary]];
    [self.portraitImageView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradientView]-(60)-[viewOverPortrait]"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:viewsDictionary]];
    [self.portraitImageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.viewOverPortrait
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.portraitImageView
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:0.0]];
    
    
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[name]-1-[nameOriginal]-1-[durationGenres]-3-|"
                                                                                  options:NSLayoutFormatAlignAllLeft
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[name]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[nameOriginal]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    [self.viewOverPortrait addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[durationGenres]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
