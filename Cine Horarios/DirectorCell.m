//
//  DirectorCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "DirectorCell.h"
#import "Actor.h"
#import "FileHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DirectorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelName.highlightedTextColor = [UIColor whiteColor];
        
        return self;
    }
    return self;
}
- (void)setActor:(Actor *)actor {
    _actor = actor;
    
    self.labelName.text = _actor.name;
    NSURL *nsurl = [FileHandler nsurlWithImagePath:_actor.imageUrl imageType:MovieImageTypeMovieImageCover];
    [self.imageCover setImageWithURL:nsurl];
    
    [self setNeedsLayout];
}
-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageCover.tag = 0;
}

+ (CGFloat)heightForCellWithActor:(Actor *)actor withFont:(UIFont *)font{
    
    CGSize size = CGSizeMake(211.f, 1000.f);
    
    CGRect nameLabelRect = [actor.name boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                         context: nil];
    
    CGFloat totalHeight = 5.0f + nameLabelRect.size.height + 5.0f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}
@end
