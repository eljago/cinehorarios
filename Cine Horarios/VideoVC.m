//
//  PlayVideoViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "VideoVC.h"
#import "VideoItem.h"
#import "UIColor+CH.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.view.backgroundColor = [UIColor tableViewColor];
    self.title = @"Videos";
    
    NSString *iFrameString = @"";
    
    for (VideoItem *videoItem in self.videos) {
        iFrameString = [iFrameString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"video\"><div class=\"title\">%@:</div><iframe width=\"%d\" height=\"%d\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen></iframe></div>", videoItem.name, 320, 180, videoItem.code]];
    }
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head>\
                           <style type=\"text/css\">\
                           body {\
                            background-color: rgb(241, 234, 227);\
                            margin: 0px;\
                            padding: 0px;\
                           }\
                           div.title {\
                            font-family: \"Helvetica Neue\";\
                            text-align: left;\
                            color: black;\
                            padding-left: 10px;\
                            padding-top: 5px;\
                            padding-bottom: 5px;\
                           }\
                           div.video {\
                            background-color: white;\
                           }\
                           </style>\
                           </head><body>%@</body></html>", iFrameString];
    
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
