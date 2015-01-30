//
//  MovieCell1+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellTextView+Movie.h"
#import "Movie.h"
#import "UITextView+CH.h"

@implementation MovieCellTextView (Movie)

- (void)configureSynpsisForMovie:(Movie *)movie {
    if (movie.information.length > 0) {
        self.textView.text = movie.information;
    }
}

- (void)configureMovieInfoForMovie:(Movie *)movie boldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont smallerFont:(UIFont *)smallerFont smallestBoldFont:(UIFont *)smallestBoldFont {
    if (movie.year || movie.rating || movie.nameOriginal.length > 0 || movie.duration || movie.debut.length > 0) {
        self.textView.attributedText = [MovieCellTextView textForMovieInforWithMovie:movie boldFont:boldFont normalFont:normalFont smallerFont:smallerFont smallestBoldFont:(UIFont *)smallestBoldFont];
    }
}

- (CGFloat) heightForRowWithFont:(UIFont *)font {
    
    return 3.f + [self.textView measureHeightUsingFont:font] + 3.f;
}
- (CGFloat) heightForAttributedTextView {
    
    return 3.f + [self.textView measureAttributedTextViewHeight] + 3.f;
}

+ (NSMutableAttributedString *) textForMovieInforWithMovie:(Movie *)movie boldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont smallerFont:(UIFont *)smallerFont smallestBoldFont:(UIFont *)smallestBoldFont{
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.name
                                                                 attributes:@{NSFontAttributeName: boldFont}]];
    
    if (movie.year) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%lu)",(long)movie.year.integerValue]
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
    }
    
    if (movie.nameOriginal.length > 0) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.nameOriginal
                                                                     attributes:@{NSFontAttributeName: smallerFont}]];
    }
    
    
    if (movie.duration || movie.rating.length > 0 || movie.genres.length > 0) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        
        if (movie.duration) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu min", (long)movie.duration.integerValue]
                                                                         attributes:@{NSFontAttributeName: smallestBoldFont}]];
            if (movie.rating || movie.genres.length > 0) {
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" - "
                                                                             attributes:@{NSFontAttributeName: normalFont}]];
            }
        }
        if (movie.genres.length > 0) {
            NSArray *ratingsArray = [movie.genres componentsSeparatedByString:@", "];
            [ratingsArray enumerateObjectsUsingBlock:^(NSString *rating, NSUInteger idx, BOOL *stop) {
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:rating
                                                                             attributes:@{NSFontAttributeName: smallestBoldFont}]];
                if (![rating isEqual:[ratingsArray lastObject]]) {
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" | "
                                                                                 attributes:@{NSFontAttributeName: smallerFont}]];
                }
            }];
            if (movie.rating.length > 0) {
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" - "
                                                                             attributes:@{NSFontAttributeName: normalFont}]];
            }
        }
        if (movie.rating.length > 0) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.rating
                                                                         attributes:@{NSFontAttributeName: smallestBoldFont}]];
        }
    }
    if (movie.debut > 0) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Estreno: %@", movie.debut]
                                                                     attributes:@{NSFontAttributeName: smallestBoldFont}]];
    }
    return text;
}

@end
