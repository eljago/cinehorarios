//
//  MovieRowOneCell+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-03-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieRowOneCell+Movie.h"
#import "Movie.h"
#import "UIImageView+CH.h"
#import "MyMultilineLabel.h"
#import "UIFont+CH.h"

@implementation MovieRowOneCell (Movie)

- (void) configurePortraitWithURL:(NSString *)portraitImageURL coverWithURL:(NSString *)coverImageURL{
    if (portraitImageURL) {
        [self.portraitImageView setImageWithStringURL:portraitImageURL movieImageType:MovieImageTypePortrait placeholderImage:nil];
    }
    if (coverImageURL) {
        [self.coverImageView setImageWithStringURL:coverImageURL movieImageType:MovieImageTypeCover];
    }
}

- (void) configureForMovie:(Movie *)movie{
    
    if (movie.information) {
        self.textViewSynopsis.text = movie.information;
    }
    else {
        self.textViewSynopsis.hidden = YES;
    }
    
    if (movie.name) {
        self.labelName.text = movie.name;
    }
    if (movie.year){
        self.labelName.text = [self.labelName.text stringByAppendingFormat:@" (%ld)",[movie.year longValue]];
    }
    if (movie.nameOriginal && ![movie.nameOriginal isEqualToString:@""]){
        self.labelNameOriginal.text = [NSString stringWithFormat:@"\"%@\"",movie.nameOriginal];
    }
    if (movie.duration) {
        self.labelDurationGenres.text = [NSString stringWithFormat:@"%ld min",[movie.duration longValue]];
    }
    if (movie.duration && movie.genres && ![movie.genres isEqualToString:@""]) {
        self.labelDurationGenres.text = [self.labelDurationGenres.text stringByAppendingString:@" - "];
    }
    if (movie.genres) {
        self.labelDurationGenres.text = [self.labelDurationGenres.text stringByAppendingFormat:@"%@",movie.genres];
    }
}

+ (CGFloat) heightForRowWithMovie:(Movie *)movie font:(UIFont *)font{

    CGRect rect = [movie.information boundingRectWithSize: CGSizeMake(304, 140)
                                                                options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                             attributes: [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                                                context: nil];

    return 246 + rect.size.height + 10.f;
}

@end
