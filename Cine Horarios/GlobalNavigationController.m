//
//  GlobalNavigationController.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-09-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GlobalNavigationController.h"
#import "MenuVC.h"
#import "REMenu.h"
#import "UIColor+CH.h"

@interface GlobalNavigationController ()
@property (nonatomic, strong) REMenu *menu;
@end

@implementation GlobalNavigationController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.canDisplayBannerAds = YES;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    int index = 0;
    for (NSDictionary *dict in menuArray) {
        NSString *name = dict[@"name"];
        UIImage *image = [[UIImage imageNamed:dict[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        NSString *storyboardID = dict[@"storyboardID"];
        
        UIView *customView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"MenuCustomView" owner:self options:nil] lastObject];
        UILabel *label = (UILabel *)[customView viewWithTag:1];
        UIImageView *imgView = (UIImageView *)[customView viewWithTag:2];
        label.text = name;
        label.highlightedTextColor = [UIColor menuColorForRow:index];
        imgView.image = image;
        imgView.tintColor = [UIColor menuColorForRow:index];
        REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
            self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:storyboardID]];
            for (REMenuItem *menuItem in self.menu.items) {
                if ([item isEqual:menuItem]) {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor menuColorForRow:index];
                }
                else {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor whiteColor];
                }
            }
        }];
        [menuItems addObject:customViewItem];
        index++;
    }
    self.menu = [[REMenu alloc] initWithItems:[NSArray arrayWithArray:menuItems]];
    self.menu.backgroundColor = [UIColor midnightBlue];
    self.menu.itemHeight = 50.f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = [menuArray firstObject][@"storyboardID"];
    }
    
    self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    [self.navigationBar setBackgroundImage:[UIImage new]
                                            forBarPosition:UIBarPositionAny
                                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.navigationBar addGestureRecognizer:swipeGesture];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)rec
{
    [self revealMenu:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark IBActions

- (IBAction)revealMenu:(id)sender {
    
    if (self.menu.isOpen)
        return [self.menu close];
    
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

#pragma mark - iAd Delegate Methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    UIView *customView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"MenuBannerView" owner:self options:nil] lastObject];
    REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:nil];
    self.menu.items = [[@[customViewItem] mutableCopy] arrayByAddingObjectsFromArray:self.menu.items];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
}

@end
