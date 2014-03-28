//
//  PlayVideoViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoVC.h"
#import "Video.h"
#import "UIColor+CH.h"
#import "GAI+CH.h"
#import "VideosVC.h"
#import "BasicMovie.h"

@interface VideoVC () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation VideoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"PELICULA VIDEOS"];
    
    self.view.backgroundColor = [UIColor tableViewColor];
    self.webView.backgroundColor = [UIColor tableViewColor];
    
    NSString *iFrameString = @"";

    if ([[self backViewController] isKindOfClass:VideosVC.class]) {
        self.title = @"Video";
        for (Video *video in self.videos) {
            iFrameString = [iFrameString stringByAppendingString:[NSString stringWithFormat:@"\
                                                                  <div class=\"video\">\
                                                                    <h3>%@</h3>\
                                                                    <h4>%@</h4>\
                                                                    <iframe width=\"%d\" height=\"%d\" src=\"http://www.youtube.com/embed/%@\" frameBorder=\"0\" allowfullscreen>\
                                                                    </iframe>\
                                                                  </div>", video.movie.name, video.name, 280, 180, video.code]];
        }
    }
    else {
        self.title = @"Videos";
        for (Video *video in self.videos) {
            iFrameString = [iFrameString stringByAppendingString:[NSString stringWithFormat:@"\
                                                                  <div class=\"video\">\
                                                                    <h4>%@</h4>\
                                                                    <iframe width=\"%d\" height=\"%d\" src=\"http://www.youtube.com/embed/%@\" frameBorder=\"0\" allowfullscreen>\
                                                                    </iframe>\
                                                                  </div>", video.name, 280, 180, video.code]];
        }
    }
    
    NSString *embedHTML = [NSString stringWithFormat:@"<!DOCTYPE html>\
                           <html><head>\
                           <title>Videos</title>\
                           <style type=\"text/css\">\
                           body {\
                           background-color: rgb(241, 234, 227);\
                           margin: 0px;\
                           padding: 0px;\
                           }\
                           h3 {\
                           font-family: \"Helvetica Neue\";\
                           font-weight: normal;\
                           color: rgb(168, 56, 48);\
                           margin-top: 0;\
                           margin-bottom: 5px;\
                           }\
                           h4 {\
                           font-family: \"Helvetica Neue\";\
                           font-weight: normal;\
                           margin-top: 0;\
                           margin-bottom: 10px;\
                           }\
                           div.video {\
                           background-color: white;\
                           margin: 10px;\
                           padding: 10px;\
                           padding-bottom: 7px;\
                           -moz-border-radius: 3px;\
                           border-radius: 3px;\
                           box-shadow: 0 0 10px #888888;\
                           }\
                           iframe { margin: 0; }\
                           </style>\
                           </head><body>%@</body></html>", iFrameString];

    [self.webView loadHTMLString:embedHTML baseURL:nil];
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Interface Orientation
    
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
