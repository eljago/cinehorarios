//
//  CastCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 30-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "ActorCell.h"
#import "Actor.h"
#import "UIImageView+CH.h"

@implementation ActorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelName.highlightedTextColor = [UIColor whiteColor];
        self.labelRole.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setActor:(Actor *)actor {
    _actor = actor;
    
    self.labelName.text = _actor.name;
    self.labelRole.text = _actor.character;
    
    [self.imageCover setImageWithStringURL:_actor.imageUrl movieImageType:MovieImageTypeMovieImageCover];
    
    [self setNeedsLayout];
}
-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageCover.tag = 0;
}

+ (CGFloat)heightForCellWithActor:(Actor *)actor withNameFont:(UIFont *)fontName roleFont:(UIFont *)fontRole {
    
    CGSize size = CGSizeMake(211.f, 1000.f);
    
    CGRect nameLabelRect = [actor.name boundingRectWithSize: size
                                                    options: NSStringDrawingUsesLineFragmentOrigin
                                                 attributes: [NSDictionary dictionaryWithObject:fontName forKey:NSFontAttributeName]
                                                    context: nil];
    CGRect roleLabelRect = [actor.character boundingRectWithSize: size
                                                    options: NSStringDrawingUsesLineFragmentOrigin
                                                 attributes: [NSDictionary dictionaryWithObject:fontRole forKey:NSFontAttributeName]
                                                    context: nil];
    
    CGFloat totalHeight = 5.0f + nameLabelRect.size.height + 10.0f + roleLabelRect.size.height + 5.f;
    
    if (totalHeight <= 82.f) {
        totalHeight = 82.f;
    }
    
    return totalHeight;
}
@end
