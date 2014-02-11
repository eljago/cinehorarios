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
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "FileHandler.h"
#import "UIView+CH.h"

@interface SettingsVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *startCinesLabel;
@property (nonatomic, weak) IBOutlet UISwitch *switchRetina;
@property (nonatomic, weak) IBOutlet UIView *closeView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *customPicker;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *customPickerBottomSpace;
@property (nonatomic, weak) IBOutlet UIImageView *indicatorImageView;

@property (nonatomic, strong) NSArray *startingVCs;
@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indicatorImageView.image = [self.indicatorImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.title = @"Ajustes";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL retinaImages = [defaults boolForKey:@"Retina Images"];
    NSString *startingVC = [defaults stringForKey:@"Starting VC"];
    
    [FileHandler getMenuDictsAndSelectedIndex:^(NSArray *menuDicts, NSInteger selectedIndex) {
        self.startingVCs = menuDicts;
        [self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
        self.startCinesLabel.text = self.startingVCs[selectedIndex][@"pickerName"];
    } withStoryboardID:startingVC];
    
    self.switchRetina.on = retinaImages;
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"AJUSTES" forKey:kGAIScreenName] build]];
    self.view.backgroundColor = [UIColor tableViewColor];
    
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
    self.customPickerBottomSpace.constant = -self.customPicker.frame.size.height;
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
    return self.startingVCs[row][@"pickerName"];
}

#pragma mark Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.startingVCs[row][@"storyboardID"] forKey:@"Starting VC"];
    [defaults synchronize];
    
    self.startCinesLabel.text = self.startingVCs[row][@"pickerName"];
}

#pragma mark - Interface Orientation
    
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
