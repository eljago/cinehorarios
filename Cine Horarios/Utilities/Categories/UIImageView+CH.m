//
//  UIImageView+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIImageView+CH.h"
#import "CineHorariosApiClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@implementation UIImageView (CH)


+ (NSString *) prefixImageURL:(NSString *)imageURL
                   withString:(NSString *)retinaString {
    
    NSMutableArray *imageArray = (NSMutableArray *)[imageURL componentsSeparatedByString:@"/"];
    NSString *newImageURL = [retinaString stringByAppendingString:[imageArray lastObject]];
    imageArray[imageArray.count-1] = newImageURL;
    
    return [imageArray componentsJoinedByString:@"/"];
}

+ (NSString *) imageURLForPath:(NSString *)imageURL imageType:(MovieImageType)movieImageType{
    NSString *imagePath;
    switch (movieImageType) {
        case MovieImageTypeCover:
            imagePath = [self prefixImageURL:imageURL withString:@"smaller_"];
            break;
        case MovieImageTypePortrait:
            imagePath = imageURL;
            break;
        case MovieImageTypeMovieImageCover:
            imagePath = [self prefixImageURL:imageURL withString:@"smaller_"];
            break;
        case MovieImageTypeMovieImageFullScreenRetina:
            imagePath = imageURL;
            break;
        case MovieImageTypeMovieImageFullScreenNoRetina:
            imagePath = [self prefixImageURL:imageURL withString:@"small_"];
            break;
        case MovieImageTypeCastFullScreenRetina:
            imagePath = imageURL;
            break;
        case MovieImageTypeCastFullScreenNoRetina:
            imagePath = [self prefixImageURL:imageURL withString:@"small_"];
            break;
        case MovieImageTypeMovieVideo:
            imagePath = [self prefixImageURL:imageURL withString:@"small_"];
            break;
            
        default:
            return nil;
            break;
    }
    if ([imagePath hasPrefix:@"/"]) {
        return [kCineHorariosAPIBaseURLString stringByAppendingPathComponent:imagePath];
    }
    else {
        return imagePath;
    }
}
- (NSURL *) nsurlWithImagePath:(NSString *)imageURL imageType:(MovieImageType)movieImageType {
    return [NSURL URLWithString:[UIImageView imageURLForPath:imageURL imageType:movieImageType]];
}

- (NSString *) getLocalImagePathForImageNamed:(NSString *)imageName {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localDirPath = [cacheDir stringByAppendingPathComponent:@"images"];
    if ([filemgr createDirectoryAtPath:localDirPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
        // Failed to create Directory
    }
    return [localDirPath stringByAppendingPathComponent:imageName];
}
- (void) setImageWithStringURL:(NSString *)imageURL
               movieImageType:(MovieImageType) movieImageType
             placeholderImage:(UIImage *)placeholderImage {
    
    NSString *imageSaveName = [[imageURL componentsSeparatedByString:@"/"] lastObject];
    NSFileManager *filemgr = [ NSFileManager defaultManager];
    NSString *localImagePath = [self getLocalImagePathForImageNamed:imageSaveName];
    
    if ([filemgr fileExistsAtPath:localImagePath]) {
        self.image = [UIImage imageWithContentsOfFile:localImagePath];
    }
    else {
        NSURL *nsurl = [self nsurlWithImagePath:imageURL imageType:movieImageType];
        
        [self setImageWithURL:nsurl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *binaryImageData = UIImagePNGRepresentation(image);
                [binaryImageData writeToFile:localImagePath atomically:YES];
            });
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}
- (void) setImageWithStringURL:(NSString *)imageURL
               movieImageType:(MovieImageType) movieImageType {
    
    NSURL *nsurl = [self nsurlWithImagePath:imageURL imageType:movieImageType];
    
    [self setImageWithURL:nsurl usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}
- (void) setImageWithStringURL:(NSString *)imageURL
                movieImageType:(MovieImageType) movieImageType
                   placeholder: (UIImage *)placeholder {
    
    NSURL *nsurl = [self nsurlWithImagePath:imageURL imageType:movieImageType];
    
    [self setImageWithURL:nsurl placeholderImage:placeholder usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
