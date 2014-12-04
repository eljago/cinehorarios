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


NSString *const kStartingVC = @"Starting VC";
NSString *const kRetinaImages = @"Retina Images";

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
    NSString *startingVC = [defaults stringForKey:kStartingVC];
    
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
    
    self.switchRetina.on = [defaults boolForKey:kRetinaImages];
    
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
    [defaults setBool:retinaImages forKey:kRetinaImages];
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
    [defaults setValue:self.startingVCs[row][@"storyboardID"] forKey:kStartingVC];
    [defaults synchronize];
    
    self.startCinesLabel.text = self.startingVCs[row][@"name"];
}

#pragma mark - Interface Orientation
    
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
