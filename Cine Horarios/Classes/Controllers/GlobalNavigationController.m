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
#import "MWPhotoBrowser.h"

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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSArray *menuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSString *identifier = [defaults stringForKey:@"Starting VC"];
    if (!identifier) {
        identifier = [menuArray firstObject][@"storyboardID"];
    }
    
    [self setupMenuWithStartingVC:identifier menuArray:menuArray];
    
    self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    
    // Set the background and shadow image to get rid of the line.
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionRight;
    [self.navigationBar addGestureRecognizer:swipeGestureDown];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.navigationBar addGestureRecognizer:swipeGestureUp];
    
    [self setupSocialButtons];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)rec
{
    if ([self.topViewController isKindOfClass:MWPhotoBrowser.class]) {
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
            label.font = [UIFont fontWithName:@"Helvetica" size:17.];
        }
        imgView.image = image;
        imgView.tintColor = [UIColor menuColorForRow:index];
        REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
            self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:storyboardID]];
            for (REMenuItem *menuItem in self.menu.items) {
                if ([item isEqual:menuItem]) {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor menuColorForRow:index];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"Helvetica" size:17.];
                }
                else {
                    ((UILabel *)[menuItem.customView viewWithTag:1]).textColor = [UIColor whiteColor];
                    ((UILabel *)[menuItem.customView viewWithTag:1]).font = [UIFont fontWithName:@"Helvetica-Light" size:17.];
                }
            }
        }];
        [menuItems addObject:customViewItem];
        index++;
    }
    self.menu = [[REMenu alloc] initWithItems:[NSArray arrayWithArray:menuItems]];
    if (![self esiOS71]) {
        self.menu.borderColor = [UIColor clearColor];
        self.menu.backgroundColor = [UIColor wetAsphalt];
        self.menu.highlightedBackgroundColor = [UIColor midnightBlue];
    }
    else {
        self.menu.liveBlur = YES;
        self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    }
    
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
    };
    self.menu.closeCompletionHandler = ^{
        __strong GlobalNavigationController *strongSelf = weakSelf;
        strongSelf.buttonFacebook.hidden = YES;
        strongSelf.buttonTwitter.hidden = YES;
    };
}

-(void) setupSocialButtons {
    
    self.buttonFacebook = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - kButtonWidth - 4., kButtonWidth, kButtonWidth)];
    [self.buttonFacebook setImage:[UIImage imageNamed:@"ButtonFacebook"] forState:UIControlStateNormal];
    [self.buttonFacebook addTarget:self action:@selector(goFacebook) forControlEvents:UIControlEventTouchUpInside];
    self.buttonTwitter = [[UIButton alloc] initWithFrame:CGRectMake(10+kButtonWidth+10, self.view.frame.size.height - kButtonWidth - 4., kButtonWidth, kButtonWidth)];
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
                                                                        constant:-5];
    [self.view addConstraint:self.facebookBottomMarginConstraint];
    self.twitterBottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.buttonTwitter
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:-5];
    [self.view addConstraint:self.twitterBottomMarginConstraint];
}

@end
