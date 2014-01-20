//
//  BillboardCell+BasicMovie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BillboardCell+BasicMovie.h"
#import "Genre.h"
#import "UIImageView+CH.h"
#import "NSArray+FKBMap.h"

@implementation BillboardCell (BasicMovie)

-(void) configureForBasicMovie:(BasicMovie2 *)basicMovie {
    self.mainLabel.text = basicMovie.name;
    if (basicMovie.duration) {
        self.durationLabel.text = [NSString stringWithFormat:@"%d minutos",basicMovie.duration];
    }
    else{
        self.durationLabel.text = @"";
    }
    if (basicMovie.genres) {
        NSArray *genresNames = [basicMovie.genres fkbMap:^NSString *(Genre *genre) {
            return genre.name;
        }];
        self.genresLabel.text = [genresNames componentsJoinedByString:@", "];
    }
    else{
        self.genresLabel.text = @"";
    }
    
    [self.imageCover setImageWithStringURL:basicMovie.imageURL movieImageType:MovieImageTypeCover];
    
}

+ (CGFloat) heightForRowWithBasicMovie:(BasicMovie2 *)basicMovie headFont:(UIFont *)headFont bodyFont:(UIFont *)bodyFont {
    NSArray *genresNames = [basicMovie.genres fkbMap:^NSString *(Genre *genre) {
        return genre.name;
    }];
    NSString *genres = [genresNames componentsJoinedByString:@", "];
    NSString *duration = [NSString stringWithFormat:@"%d", basicMovie.duration];
    
    CGSize size = CGSizeMake(187.f, 1000.f);
    
    CGRect nameLabelRect = [basicMovie.name boundingRectWithSize: size
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                      attributes: [NSDictionary dictionaryWithObject:headFont forKey:NSFontAttributeName]
                                                         context: nil];
    CGRect typesLabelRect = [genres boundingRectWithSize: size
                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                              attributes: [NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]
                                                 context: nil];
    CGRect showtimesLabelRect = [duration boundingRectWithSize: size
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
