//
//  Cartelera.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 28-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CarteleraCell.h"
#import "BasicMovie.h"
#import "UIImageView+CH.h"

@implementation CarteleraCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    
    self.labelName.highlightedTextColor = [UIColor whiteColor];
    self.labelDuration.highlightedTextColor = [UIColor whiteColor];
    self.labelGenres.highlightedTextColor = [UIColor whiteColor];
    
    return self;
}

- (void)setBasicMovie:(BasicMovie *)basicMovie {
    _basicMovie = basicMovie;
    
    self.labelName.text = _basicMovie.name;
    if (_basicMovie.duration) {
        self.labelDuration.text = _basicMovie.duration;
    }
    else{
        self.labelDuration.text = @"";
    }
    if (_basicMovie.genres) {
        self.labelGenres.text = _basicMovie.genres;
    }
    else{
        self.labelGenres.text = @"";
    }
    
    [_imageCover setImageWithStringURL:_basicMovie.imageUrl movieImageType:MovieImageTypeCover placeholderImage:nil];
    
    [self setNeedsLayout];
}

-(void)setBodyFont:(UIFont *)bodyFont headFont:(UIFont *)headFont {
    self.labelName.font = headFont;
    self.labelDuration.font = bodyFont;
    self.labelGenres.font = bodyFont;
}

+ (CGFloat)heightForCellWithBasicItem:(BasicMovie *)basicMovie withBodyFont:(UIFont *)bodyFont headFont: (UIFont *)headFont{
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [basicMovie.name boundingRectWithSize: size
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: [NSDictionary dictionaryWithObject:headFont forKey:NSFontAttributeName]
                                                       context: nil];
    CGRect typesLabelRect = [basicMovie.genres boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect showtimesLabelRect = [basicMovie.duration boundingRectWithSize: size
                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                              attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                                 context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 15.0f + typesLabelRect.size.height + 5.0f + showtimesLabelRect.size.height + 10.0f;
    
    if (totalHeight <= 140.f) {
        totalHeight = 140.f;
    }
    
    return totalHeight;
}

@end
