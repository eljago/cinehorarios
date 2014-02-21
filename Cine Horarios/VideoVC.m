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
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
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
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA VIDEOS" forKey:kGAIScreenName] build]];
    
    self.title = @"Videos";
    
    self.view.backgroundColor = [UIColor tableViewColor];
    self.webView.backgroundColor = [UIColor tableViewColor];
    
    NSString *iFrameString = @"";
    NSString *aditionalCSS;
    if ([self.navigationController.viewControllers[0] isKindOfClass:VideosVC.class]) {
        
        for (Video *video in self.videos) {
            iFrameString = [iFrameString stringByAppendingString:[NSString stringWithFormat:@"\
                                                                  <div class=\"video\">\
                                                                    <h3>%@</h3>\
                                                                    <h4>%@</h4>\
                                                                    <iframe width=\"%d\" height=\"%d\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen>\
                                                                    </iframe>\
                                                                  </div>", video.movie.name, video.name, 320, 180, video.code]];
        }
        aditionalCSS = [NSString stringWithFormat:@"\
                        div.video {\
                        height: %d;\
                        }", (int)(self.webView.bounds.size.height-88)];
    }
    else {
        for (Video *video in self.videos) {
            iFrameString = [iFrameString stringByAppendingString:[NSString stringWithFormat:@"\
                                                                  <div class=\"video\">\
                                                                    <h3>%@</h3>\
                                                                    <iframe width=\"%d\" height=\"%d\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen>\
                                                                    </iframe>\
                                                                  </div>", video.name, 320, 180, video.code]];
        }
    }
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head>\
                           <style type=\"text/css\">\
                           body {\
                           background-color: rgb(241, 234, 227);\
                            margin: 0px;\
                            padding: 0px;\
                           }\
                           h1, h2, h3, h4 {\
                           font-family: \"Helvetica Neue\";\
                           margin-left: 5px;\
                           margin-top: 5px;\
                           }\
                           div.video {\
                           background-color: rgb(241, 234, 227);\
                           }\
                           %@\
                           </style>\
                           </head><body>%@</body></html>", aditionalCSS, iFrameString];
    NSLog(@"%@",embedHTML);
    [self.webView loadHTMLString:embedHTML baseURL:nil];
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
