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

@interface SettingsVC ()

@property (nonatomic, strong) IBOutlet UISwitch *switchRetina;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
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
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"AJUSTES" forKey:kGAIScreenName] build]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL retinaImages = [defaults boolForKey:@"Retina Images"];
    
    self.switchRetina.on = retinaImages;
    self.view.backgroundColor = [UIColor tableViewColor];
    
    normalFont = [UIFont getSizeForCHFont:CHFontStyleNormal forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    titleFont = [UIFont getSizeForCHFont:CHFontStyleNormalBold forPreferedContentSize:[[UIApplication sharedApplication] preferredContentSizeCategory]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    
    self.label.text = @"Active esta opción para que las imágenes en pantalla completa sean de alta resolución.";
    self.label.font = normalFont;
    self.labelTitle.font = titleFont;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor tableViewColor];
    }
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
