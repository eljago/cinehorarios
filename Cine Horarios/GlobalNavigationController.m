//
//  GlobalNavigationController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GlobalNavigationController.h"
#import "REMenu.h"
#import "UIColor+CH.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "MWPhotoBrowser.h"
#import "MovieImagesVC.h"

#define kSampleAdUnitID @"ca-app-pub-8355329926077535/7444865605"

@interface GlobalNavigationController ()
@property (nonatomic, strong) REMenu *menu;
@end

@implementation GlobalNavigationController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBanner];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = [menuArray firstObject][@"storyboardID"];
    }
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    int index = 0;
    for (NSDictionary *dict in menuArray) {
        NSString *name = dict[@"name"];
        UIImage *image = [[UIImage imageNamed:dict[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        NSString *storyboardID = dict[@"storyboardID"];
        
        UIView *customView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"MenuCustomView" owner:self options:nil] lastObject];
        UILabel *label = (UILabel *)[customView viewWithTag:1];
        label.textColor = [UIColor whiteColor];
        UIImageView *imgView = (UIImageView *)[customView viewWithTag:2];
        label.text = name;
        if ([identifier isEqualToString:storyboardID]) {
            label.textColor = [UIColor menuColorForRow:index];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.];
            customView.backgroundColor = [UIColor midnightBlue];
        }
        imgView.image = image;
        imgView.tintColor = [UIColor menuColorForRow:index];
        REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
            self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:storyboardID]];
            for (REMenuItem *menuItem in self.menu.items) {
                if ([item isEqual:menuItem]) {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor menuColorForRow:index];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.];
                    menuItem.customView.backgroundColor = [UIColor midnightBlue];
                }
                else {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor whiteColor];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.];
                    menuItem.customView.backgroundColor = [UIColor clearColor];
                }
            }
        }];
        [menuItems addObject:customViewItem];
        index++;
    }
    self.menu = [[REMenu alloc] initWithItems:[NSArray arrayWithArray:menuItems]];
    self.menu.borderColor = [UIColor clearColor];
    self.menu.backgroundColor = [UIColor wetAsphalt];
    self.menu.highlightedBackgroundColor = [UIColor midnightBlue];
//    self.menu.liveBlurTintColor = [UIColor midnightBlueLight];
//    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleLight;
//    self.menu.liveBlur = YES;
    self.menu.separatorHeight = 0.;
    self.menu.itemHeight = 44.f;
    __weak GlobalNavigationController *weakSelf = self;
    self.menu.closeCompletionHandler = ^{
        __strong GlobalNavigationController *strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.adBanner.alpha = 0.;
        } completion:^(BOOL finished) {
            strongSelf.adBanner.hidden = YES;
        }];
    };
    
    self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    [self.navigationBar setBackgroundImage:[UIImage new]
                                            forBarPosition:UIBarPositionAny
                                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionRight;
    [self.navigationBar addGestureRecognizer:swipeGestureDown];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.navigationBar addGestureRecognizer:swipeGestureUp];
}

- (void)dealloc {
    self.adBanner.delegate = nil;
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)rec
{
    if ([self.topViewController isKindOfClass:MWPhotoBrowser.class] || [self.topViewController isKindOfClass:MovieImagesVC.class]) {
        return;
    }
    [self revealMenu:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark IBActions

- (IBAction)revealMenu:(id)sender {
    
    if (self.menu.isOpen)
        return [self.menu close];
    
    self.adBanner.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.adBanner.alpha = 1.;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.adBanner];
    }];
    [self.menu showFromNavigationController:self];
}
- (IBAction)goSocial:(UIButton *)sender {
    
    if (sender.tag == 20) {
        NSURL *facebookURL = [NSURL URLWithString:@"twitter://user?screen_name=CineHorarios"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/CineHorarios"]];
        }
    }
    else if(sender.tag == 21) {
        NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/469307943155757"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/AppCineHorarios"]];
        }
    }
}

#pragma mark - Supported Orientations

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}


#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"a0184615f470d137bb602d55d2d32efb98e2d063" ];
    return request;
}

#pragma mark - Banner

- (void) setupBanner {
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    self.adBanner.alpha = 0.;
    self.adBanner.hidden = YES;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//    NSLog(@"Received ad successfully");
    [UIView animateWithDuration:0.3 animations:^{
        self.adBanner.alpha = 1.;
    }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
    [UIView animateWithDuration:0.3 animations:^{
        self.adBanner.alpha = 0.;
    } completion:^(BOOL finished) {
    }];
}

@end
