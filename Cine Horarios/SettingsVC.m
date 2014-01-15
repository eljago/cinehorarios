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

@property (nonatomic, strong) IBOutlet UISwitch *switchRetina;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *startingVCs;
@end

@implementation SettingsVC {
    UIFont *normalFont;
    UIFont *titleFont;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Ajustes";
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"AJUSTES" forKey:kGAIScreenName] build]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL retinaImages = [defaults boolForKey:@"Retina Images"];
    NSString *startingVC = [defaults stringForKey:@"Starting VC"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSMutableArray *menu = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
    [menu removeLastObject];
    
    [FileHandler getMenuDictsAndSelectedIndex:^(NSArray *menuDicts, NSInteger selectedIndex) {
        self.startingVCs = menuDicts;
        [self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    } withStoryboardID:startingVC];
    
    self.switchRetina.on = retinaImages;
    self.view.backgroundColor = [UIColor tableViewColor];
    
    normalFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    titleFont = [UIFont getSizeForCHFont:CHFontStyleNormalBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    self.label.text = @"Active esta opción para que las imágenes en pantalla completa sean de alta resolución.";
    self.label.font = normalFont;
    self.labelTitle.font = titleFont;
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *text;
    switch (section) {
        case 0:
            text = @"Ventana de Inicio";
            break;
        case 1:
            text = @"Imágenes";
            break;
            
        default:
            text = @"";
            break;
    }
    NSInteger height = [UIView heightForHeaderViewWithText:text font:normalFont];
    return [UIView headerViewForText:text font:normalFont height:height];
}

#pragma mark Row & Height Calculators

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIView heightForHeaderViewWithText:@"Javier" font:normalFont];
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
}

#pragma mark - content Size Changed

- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    normalFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    titleFont = [UIFont getSizeForCHFont:CHFontStyleNormalBold forPreferedContentSize:aNotification.userInfo[UIContentSizeCategoryNewValueKey]];
    self.label.font = normalFont;
    self.labelTitle.font = titleFont;

}

#pragma mark - Interface Orientation
    
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
