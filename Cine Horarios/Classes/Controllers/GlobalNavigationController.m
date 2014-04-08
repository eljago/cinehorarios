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
//#import <StoreKit/StoreKit.h>
//#import "IAPConstants.h"

#define kSampleAdUnitID @"ca-app-pub-8355329926077535/7444865605"
const CGFloat kButtonWidth = 50.f;

@interface GlobalNavigationController ()
@property (nonatomic, strong) REMenu *menu;
@property (nonatomic, strong) UIButton *buttonFacebook;
@property (nonatomic, strong) UIButton *buttonTwitter;
@property (nonatomic, strong) NSLayoutConstraint *facebookLeftMarginConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterRightMarginConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookBottomMarginConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterBottomMarginConstraint;
@end

@implementation GlobalNavigationController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    if (![defaults boolForKey:RemoveAddsInAppIdentifier]) {
        [self setupBanner];
//    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = [menuArray firstObject][@"storyboardID"];
    }
    
    [self setupMenuWithStartingVC:identifier menuArray:menuArray];
    
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
    
    [self setupSocialButtons];
//    [self updateBottomMarinConstraintsConstant];
    self.facebookBottomMarginConstraint.constant = -CGSizeFromGADAdSize(kGADAdSizeBanner).height-4;
    self.twitterBottomMarginConstraint.constant = -CGSizeFromGADAdSize(kGADAdSizeBanner).height-4;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

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
    
    if (self.menu.isOpen) {
        return [self.menu close];
    }
    
    self.buttonTwitter.hidden = NO;
    self.buttonFacebook.hidden = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.facebookLeftMarginConstraint.constant = 10;
         self.twitterRightMarginConstraint.constant = 10+kButtonWidth+10;
         [self.view layoutIfNeeded];
     } completion:^(BOOL finished) {
         [self.view bringSubviewToFront:self.buttonFacebook];
         [self.view bringSubviewToFront:self.buttonTwitter];
     }];
    
    if (self.adBanner) {
        self.adBanner.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.adBanner.alpha = 1.;
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:self.adBanner];
        }];
    }

    [self.menu showFromNavigationController:self];
}
- (void)goFacebook {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/469307943155757"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/AppCineHorarios"]];
    }
}
- (void) goTwitter {
    NSURL *facebookURL = [NSURL URLWithString:@"twitter://user?screen_name=CineHorarios"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/CineHorarios"]];
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

//#pragma mark - Product Purchased
//
//
//- (void)productPurchased:(NSNotification *)notification {
//    
//    NSString * productIdentifier = notification.object;
//    if ([productIdentifier isEqualToString:RemoveAddsInAppIdentifier]) {
//        self.adBanner.hidden = YES;
//        self.adBanner = nil;
//    }
//}

//#pragma mark - Update Bottom Margin Constraints Constant
//
//- (void) updateBottomMarinConstraintsConstant {
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:RemoveAddsInAppIdentifier]) {
//        self.facebookBottomMarginConstraint.constant = -4;
//        self.twitterBottomMarginConstraint.constant = -4;
//    } else {
//        self.facebookBottomMarginConstraint.constant = -CGSizeFromGADAdSize(kGADAdSizeBanner).height-4;
//        self.twitterBottomMarginConstraint.constant = -CGSizeFromGADAdSize(kGADAdSizeBanner).height-4;
//    }
//}

#pragma mark - Setup Stuff

- (void) setupMenuWithStartingVC: (NSString *)identifier menuArray:(NSArray *)menuArray {
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
            label.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17.];
        }
        imgView.image = image;
        imgView.tintColor = [UIColor menuColorForRow:index];
        REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
            self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:storyboardID]];
            for (REMenuItem *menuItem in self.menu.items) {
                if ([item isEqual:menuItem]) {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor menuColorForRow:index];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"ProximaNova-Regular" size:17.];
                }
                else {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor whiteColor];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"ProximaNova-Light" size:17.];
                }
            }
        }];
        [menuItems addObject:customViewItem];
        index++;
    }
    self.menu = [[REMenu alloc] initWithItems:[NSArray arrayWithArray:menuItems]];
//    self.menu.borderColor = [UIColor clearColor];
//    self.menu.backgroundColor = [UIColor wetAsphalt];
//    self.menu.highlightedBackgroundColor = [UIColor midnightBlue];
    
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    
    self.menu.separatorHeight = 0.;
    self.menu.itemHeight = 44.f;
    __weak GlobalNavigationController *weakSelf = self;
    self.menu.closePreparationBlock = ^{
        __strong GlobalNavigationController *strongSelf = weakSelf;
        
        [strongSelf.view layoutIfNeeded];
        [UIView animateWithDuration:1.3
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:-4.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             strongSelf.facebookLeftMarginConstraint.constant = -kButtonWidth;
             strongSelf.twitterRightMarginConstraint.constant = -kButtonWidth;
             [strongSelf.view layoutIfNeeded];
         } completion:nil];
        
        if (strongSelf.adBanner) {
            [UIView animateWithDuration:0.3 animations:^{
                strongSelf.adBanner.alpha = 0.;
            } completion:^(BOOL finished) {
                strongSelf.adBanner.hidden = YES;
            }];
        }
    };
    self.menu.closeCompletionHandler = ^{
        __strong GlobalNavigationController *strongSelf = weakSelf;
        strongSelf.buttonFacebook.hidden = YES;
        strongSelf.buttonTwitter.hidden = YES;
    };
}

-(void) setupSocialButtons {
    
    self.buttonFacebook = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - kButtonWidth - 4., kButtonWidth, kButtonWidth)];
    [self.buttonFacebook setImage:[UIImage imageNamed:@"ButtonFacebook"] forState:UIControlStateNormal];
    [self.buttonFacebook addTarget:self action:@selector(goFacebook) forControlEvents:UIControlEventTouchUpInside];
    self.buttonTwitter = [[UIButton alloc] initWithFrame:CGRectMake(10+kButtonWidth+10, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - kButtonWidth - 4., kButtonWidth, kButtonWidth)];
    [self.buttonTwitter setImage:[UIImage imageNamed:@"ButtonTwitter"] forState:UIControlStateNormal];
    [self.buttonTwitter addTarget:self action:@selector(goTwitter) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonFacebook.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonTwitter.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.buttonFacebook];
    [self.view addSubview:self.buttonTwitter];
    
    self.twitterRightMarginConstraint = [NSLayoutConstraint constraintWithItem:self.buttonTwitter
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:-kButtonWidth];
    [self.view addConstraint:self.twitterRightMarginConstraint];
    self.facebookLeftMarginConstraint = [NSLayoutConstraint constraintWithItem:self.buttonFacebook
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:-kButtonWidth];
    [self.view addConstraint:self.facebookLeftMarginConstraint];
    self.facebookBottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.buttonFacebook
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:self.facebookBottomMarginConstraint];
    self.twitterBottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.buttonTwitter
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:self.twitterBottomMarginConstraint];
}

@end
