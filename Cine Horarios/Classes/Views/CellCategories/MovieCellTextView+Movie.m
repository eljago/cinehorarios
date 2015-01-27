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

- (void)configureMovieInfoForMovie:(Movie *)movie boldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont {
    if (movie.year || movie.rating || movie.nameOriginal.length > 0 || movie.duration || movie.debut.length > 0) {
        self.textView.attributedText = [MovieCellTextView textForMovieInforWithMovie:movie boldFont:boldFont normalFont:normalFont];
    }
}

- (CGFloat) heightForRowWithFont:(UIFont *)font {
    
    return 3.f + [self.textView measureHeightUsingFont:font] + 3.f;
}
- (CGFloat) heightForAttributedTextView {
    
    return 3.f + [self.textView measureAttributedTextViewHeight] + 3.f;
}

+ (NSMutableAttributedString *) textForMovieInforWithMovie:(Movie *)movie boldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont {
    BOOL placeLineBreak = NO;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    if (movie.nameOriginal.length > 0) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Nombre Original: "
                                                                     attributes:@{NSFontAttributeName: boldFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.nameOriginal
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        placeLineBreak = YES;
    }
    if (movie.duration) {
        if (placeLineBreak)
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                         attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Duración: "
                                                                     attributes:@{NSFontAttributeName: boldFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu minutos", (long)movie.duration.integerValue]
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        placeLineBreak = YES;
    }
    if (movie.year) {
        if (placeLineBreak)
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                         attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Año: "
                                                                     attributes:@{NSFontAttributeName: boldFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu",(long)movie.year.integerValue]
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        placeLineBreak = YES;
    }
    if (movie.rating) {
        if (placeLineBreak)
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Calificación: "
                                                                     attributes:@{NSFontAttributeName: boldFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.rating
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
        placeLineBreak = YES;
    }
    if (movie.debut > 0) {
        if (placeLineBreak)
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"
                                                                         attributes:@{NSFontAttributeName: normalFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Estreno: "
                                                                     attributes:@{NSFontAttributeName: boldFont}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:movie.debut
                                                                     attributes:@{NSFontAttributeName: normalFont}]];
    }
    return text;
}

@end
