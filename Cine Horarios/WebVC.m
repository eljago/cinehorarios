//
//  InfoViewController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-06-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "WebVC.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface WebVC ()
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation WebVC

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
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"PELICULA WEB VIEW" forKey:kGAIScreenName] build]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebBackward"] style:UIBarButtonItemStylePlain target:self action:@selector(webBack:)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebForward"] style:UIBarButtonItemStylePlain target:self action:@selector(webForward:)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebReload"] style:UIBarButtonItemStylePlain target:self action:@selector(webReload:)];
    
    self.navigationItem.rightBarButtonItems = @[forwardButton, backButton, reloadButton];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self loadPage:nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void) loadPage:(id)sender{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) webBack:(id) sender {
    [self.webView goBack];
}
-(void) webForward:(id) sender {
    [self.webView goForward];
}
-(void) webReload:(id) sender {
    [self.webView reload];
}
-(void) webStop:(id) sender {
    [self.webView stopLoading];
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
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
