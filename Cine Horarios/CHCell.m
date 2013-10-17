//
//  CHCell.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 05-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CHCell.h"
#import "UIColor+CH.h"
#import "BasicItem.h"

@implementation CHCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor belizeHole];
    [self setSelectedBackgroundView:bgColorView];
    
    _labelTitle.highlightedTextColor = [UIColor whiteColor];
    
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setBasicItem:(BasicItem *)basicItem {
    _basicItem = basicItem;
    
    _labelTitle.text = _basicItem.name;
    
    [self setNeedsLayout];
}
-(void)setFont:(UIFont *)font {
    _labelTitle.font = font;
}

+ (CGFloat)heightForCellWithBasicItem:(BasicItem *)basicItem withFont:(UIFont *)font {
    CGSize size = CGSizeMake(270.0, 1000.0);
    
    CGRect nameLabelRect = [basicItem.name boundingRectWithSize: size
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                   context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
    
    return totalHeight;
}

@end
