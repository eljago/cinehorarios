//
//  ComingSoonCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ComingSoonCell.h"
#import "BasicMovie.h"
#import "UIImageView+CH.h"

@implementation ComingSoonCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    
    self.labelName.highlightedTextColor = [UIColor whiteColor];
    self.labelEstreno.highlightedTextColor = [UIColor whiteColor];
    self.labelDebut.highlightedTextColor = [UIColor whiteColor];
    
    return self;
}

- (void)setBasicMovie:(BasicMovie *)basicMovie {
    _basicMovie = basicMovie;
    
    self.labelName.text = _basicMovie.name;
    if (basicMovie.debut) {
        self.labelEstreno.text = @"Estreno:";
        self.labelDebut.text = basicMovie.debut;
    }
    else{
        self.labelEstreno.text = @"";
        self.labelDebut.text = @"";
    }
    [self.imageCover setImageWithStringURL:_basicMovie.imageUrl movieImageType:MovieImageTypeCover];
    
    [self setNeedsLayout];
}

-(void)setBodyFont:(UIFont *)bodyFont headFont:(UIFont *)headFont {
    self.labelName.font = headFont;
    self.labelEstreno.font = bodyFont;
    self.labelDebut.font = bodyFont;
}

+ (CGFloat)heightForCellWithBasicItem:(BasicMovie *)basicMovie withBodyFont:(UIFont *)bodyFont headFont: (UIFont *)headFont{
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [basicMovie.name boundingRectWithSize: size
                                                    options: NSStringDrawingUsesLineFragmentOrigin
                                                 attributes: [NSDictionary dictionaryWithObject:headFont forKey:NSFontAttributeName]
                                                    context: nil];
    CGRect durationLabelRect = [@"Estreno:" boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect genresLabelRect = [basicMovie.debut boundingRectWithSize: size
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: [NSDictionary dictionaryWithObject:bodyFont
                                                                                            forKey:NSFontAttributeName]
                                                       context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 15.0f + durationLabelRect.size.height + 5.0f + genresLabelRect.size.height + 10.0f;
    
    if (totalHeight < 140.f) {
        totalHeight = 140.f;
    }
    
    return totalHeight;
}

@end
