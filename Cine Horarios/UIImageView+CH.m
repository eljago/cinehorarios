//
//  UIImageView+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIImageView+CH.h"
#import "CineHorariosApiClient.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation UIImageView (CH)


+ (NSString *) prefixImageURL:(NSString *)imageURL
                   withString:(NSString *)retinaString {
    
    NSMutableArray *imageArray = (NSMutableArray *)[imageURL componentsSeparatedByString:@"/"];
    NSString *newImageURL;
    newImageURL = [retinaString stringByAppendingString:[imageArray lastObject]];
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
            imagePath = [self prefixImageURL:imageURL withString:@""];
            break;
        case MovieImageTypeMovieImageCover:
            imagePath = [self prefixImageURL:imageURL withString:@"smaller_"];
            break;
        case MovieImageTypeMovieImageFullScreenRetina:
            imagePath = [self prefixImageURL:imageURL withString:@""];
            break;
        case MovieImageTypeMovieImageFullScreenNoRetina:
            imagePath = [self prefixImageURL:imageURL withString:@"small_"];
            break;
        case MovieImageTypeCastFullScreenRetina:
            imagePath = [self prefixImageURL:imageURL withString:@""];
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
    return [kCineHorariosAPIBaseURLString stringByAppendingPathComponent:imagePath];
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
        NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
        
        __weak UIImageView *wself = self;
        [self setImageWithURLRequest:request placeholderImage:nil
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 
                                 __strong UIImageView *sself = wself;
                                 if (!sself.image) {
                                     sself.image = image;
                                 }
                                 
                                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                     
                                     NSString *imageName = [[localImagePath componentsSeparatedByString:@"/"] lastObject];
                                     NSData *binaryImageData = UIImagePNGRepresentation(image);
                                     NSString *filePath = [sself getLocalImagePathForImageNamed:imageName];
                                     [binaryImageData writeToFile:filePath atomically:YES];
                                 });
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 
                             }];
    }
}
- (void) setImageWithStringURL:(NSString *)imageURL
               movieImageType:(MovieImageType) movieImageType {
    
    NSURL *nsurl = [self nsurlWithImagePath:imageURL imageType:movieImageType];
    [self setImageWithURL:nsurl];
}

@end
