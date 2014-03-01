//
//  SettingsVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "SettingsVC.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"
#import "GAI+CH.h"
#import "FileHandler.h"
#import "UIView+CH.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "IAPConstants.h"
#import "GlobalNavigationController.h"

@interface SettingsVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *startCinesLabel;
@property (nonatomic, weak) IBOutlet UISwitch *switchRetina;
@property (nonatomic, weak) IBOutlet UIView *closeView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *customPicker;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *customPickerBottomSpace;
@property (nonatomic, weak) IBOutlet UIImageView *indicatorImageView;

@property (nonatomic, weak) IBOutlet UIButton *purchaseButton;
@property (nonatomic, weak) IBOutlet UIButton *purchaseRefreshButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintPurchaseButtonWidth;
@property (nonatomic, weak) IBOutlet UILabel *labelSuggestion;

@property (nonatomic, strong) NSArray *startingVCs;
// SKProducts
@property (nonatomic, strong) NSArray *products;


@end

@implementation SettingsVC {
    NSNumberFormatter * _priceFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GAI trackPage:@"AJUSTES"];
    
    self.indicatorImageView.image = [self.indicatorImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.title = @"Ajustes";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL retinaImages = [defaults boolForKey:@"Retina Images"];
    NSString *startingVC = [defaults stringForKey:@"Starting VC"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    self.startingVCs = [NSArray arrayWithContentsOfFile:filePath];
    
    if (!startingVC) {
        startingVC = [self.startingVCs firstObject][@"storyboardID"];
    }
    
    int index = 0;
    for (NSDictionary *dict in self.startingVCs) {
        
        if ([dict[@"storyboardID"] isEqualToString:startingVC]) {
            [self.pickerView selectRow:index inComponent:0 animated:NO];
            self.startCinesLabel.text = dict[@"name"];
        }
        index++;
    }
    
    self.switchRetina.on = retinaImages;
    
    self.view.backgroundColor = [UIColor tableViewColor];
    
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
    self.customPickerBottomSpace.constant = -self.customPicker.frame.size.height;
    
    [self setupInAppPurchaseStuff];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)togglePickerView:(id)sender
{
    if (self.closeView.isHidden) {
        self.closeView.hidden = NO;
    }
    if (self.customPickerBottomSpace.constant != 0) {
        self.customPickerBottomSpace.constant = 0;
    }
    else {
        self.customPickerBottomSpace.constant = -self.customPicker.frame.size.height;
    }
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        if (self.closeView.alpha == 0.) {
            self.closeView.alpha = 0.3;
        }
        else {
            self.closeView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        if (self.closeView.alpha == 0.) {
            self.closeView.hidden = YES;
        }
    }];
}
-(IBAction)colorControl:(UIControl *)sender {
    sender.backgroundColor = [UIColor lightGrayColor];
}
-(IBAction)decolorControl:(UIControl *)sender {
    sender.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleSwitchRetina:(id)sender {
    BOOL retinaImages = self.switchRetina.on;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:retinaImages forKey:@"Retina Images"];
    [defaults synchronize];
}

#pragma mark - PickerView
#pragma mark DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.startingVCs.count-1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.startingVCs[row][@"name"];
}

#pragma mark Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.startingVCs[row][@"storyboardID"] forKey:@"Starting VC"];
    [defaults synchronize];
    
    self.startCinesLabel.text = self.startingVCs[row][@"name"];
}

#pragma mark - Interface Orientation
    
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - In-App Purchase

#pragma mark Button Pressed
-(IBAction)removeAddButtonPressed:(id)sender {
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product];
}

#pragma mark Other Methods

-(void) setupInAppPurchaseStuff {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = self.purchaseButton.center;
    [activityIndicator startAnimating];
    
    self.products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            SKProduct *product = [self.products firstObject];
            [self.purchaseButton setTitle:[product localizedTitle] forState:UIControlStateNormal];
            self.purchaseButton.enabled = YES;
            [activityIndicator removeFromSuperview];
            
            if ([[RageIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
                // User purchased the product
                self.purchaseButton.backgroundColor = [UIColor nephritis];
                [self.purchaseButton setTitle:@"Banner Eliminado" forState:UIControlStateNormal];
                self.purchaseButton.userInteractionEnabled = NO;
                
                self.purchaseRefreshButton.hidden = YES;
                self.purchaseRefreshButton.enabled = NO;
                [(GlobalNavigationController *)self.navigationController updateBottomMarinConstraintsConstant];
            } else {
                // User did not purchase the product
                self.labelSuggestion.hidden = NO;
                
                self.purchaseButton.backgroundColor = [UIColor navColor];
                [_priceFormatter setLocale:[product priceLocale]];
                NSString *priceString = [_priceFormatter stringFromNumber:[product price]];
                [self.purchaseButton setTitle:[NSString stringWithFormat:@"Eliminar (%@ USD)",priceString] forState:UIControlStateNormal];
                self.purchaseButton.userInteractionEnabled = YES;
                self.purchaseButton.tag = 0;
                [self.purchaseButton addTarget:self action:@selector(removeAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                self.purchaseRefreshButton.hidden = NO;
                self.purchaseRefreshButton.backgroundColor = [UIColor emerald];
                self.purchaseRefreshButton.enabled = YES;
                [self.purchaseRefreshButton setImage:[self.purchaseRefreshButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                self.purchaseRefreshButton.imageView.tintColor = [UIColor whiteColor];
                [self.purchaseRefreshButton addTarget:self action:@selector(restoreTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [self.view layoutIfNeeded];
                self.purchaseRefreshButton.alpha = 0.;
                [UIView animateWithDuration:0.3 animations:^{
                    self.constraintPurchaseButtonWidth.constant = 262.f;
                    self.purchaseRefreshButton.alpha = 1.;
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }];
    
    // Price Formatter setup
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            self.purchaseButton.backgroundColor = [UIColor nephritis];
            [self.purchaseButton setTitle:@"Banner Eliminado" forState:UIControlStateNormal];
            self.purchaseButton.userInteractionEnabled = NO;
            
            self.labelSuggestion.hidden = YES;

            self.purchaseRefreshButton.enabled = NO;
            
            [(GlobalNavigationController *)self.navigationController updateBottomMarinConstraintsConstant];
            
            [self.view layoutIfNeeded];
            self.purchaseRefreshButton.alpha = 1.;
            [UIView animateWithDuration:0.3 animations:^{
                self.constraintPurchaseButtonWidth.constant = 304.f;
                self.purchaseRefreshButton.alpha = 0.;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.purchaseRefreshButton.hidden = YES;
            }];
            *stop = YES;
        }
    }];
}
- (IBAction)restoreTapped:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}


@end
