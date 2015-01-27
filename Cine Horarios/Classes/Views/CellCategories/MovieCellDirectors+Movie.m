//
//  MovieCell4+Movie.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 24-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MovieCellDirectors+Movie.h"
#import "Person.h"

@implementation MovieCellDirectors (Movie)

- (void) configureCellForDirectors:(NSArray *)directors {
    Person *director = [directors firstObject];
    self.labelDirectors.text = director.name;
    if (directors.count > 1) {
        for (int i=1; i<directors.count; i++) {
            Person *director2 = directors[i];
            self.labelDirectors.text = [self.labelDirectors.text stringByAppendingFormat:@", %@",director2.name];
        }
    }
}

+ (CGFloat) heightForRowWithFont:(UIFont *)font directors:(NSArray *)directors{
    CGSize size = CGSizeMake(277.f, FLT_MAX);
    
    NSMutableArray *directorsNames = [[NSMutableArray alloc] init];
    for (Person *director in directors) {
        [directorsNames addObject:director.name];
    }
    CGRect nameLabelRect = [[directorsNames componentsJoinedByString:@", "] boundingRectWithSize: size
                                                                                         options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                      attributes: @{NSFontAttributeName: font}
                                                                                         context: nil];
    
    CGFloat totalHeight = 10.0f + nameLabelRect.size.height + 10.0f;
    
    return totalHeight;
}


@end
