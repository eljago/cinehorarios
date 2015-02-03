//
//  CuponesVC.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-02-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "CuponesVC.h"

#import <GeoFaroKit/PromocionViewController.h>
#import <GeoFaroKit/GFKInterface.h>
#import "Geofaro.h"
#import "PromocionGeoViewController.h"
#import "UIColor+CH.h"
#import "SIAlertView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CuponesVC () <UITableViewDataSource,UITableViewDelegate, CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablaCupones;
@property (weak, nonatomic) IBOutlet UIImageView *emptyDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;

@property (nonatomic,strong) NSMutableArray *listaCupones;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@end

@implementation CuponesVC {
    BOOL viewAppeared;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        GFKInterface *interface =[NSClassFromString(@"GFKInterface") sharedGFKInterface];
        _listaCupones = [[NSMutableArray alloc] initWithArray:[interface listaAnunciosGuardados]];
    }else{
        
        Geofaro *miGeofaro = [Geofaro sharedGeofaro];
        _listaCupones = [[NSMutableArray alloc] initWithArray:[miGeofaro promociones]];
        
    }
    if (_listaCupones.count > 0) {
        self.emptyDataImageView.hidden = YES;
        self.emptyDataLabel.hidden = YES;
        self.tablaCupones.hidden = NO;
        [_tablaCupones reloadData];
    }
    else {
        self.emptyDataImageView.hidden = NO;
        self.emptyDataLabel.hidden = NO;
        self.tablaCupones.hidden = YES;
    }
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(revealMenu:)];
    self.navigationItem.rightBarButtonItem = menuButtonItem;
    
    
    self.view.backgroundColor = [UIColor tableViewColor];
    self.tablaCupones.backgroundColor = [UIColor tableViewColor];
    self.tablaCupones.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:[NSNumber numberWithBool:NO]}];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (viewAppeared) {
        if (_listaCupones.count > 0) {
            self.emptyDataImageView.hidden = YES;
            self.emptyDataLabel.hidden = YES;
            self.tablaCupones.hidden = NO;
            [_tablaCupones reloadData];
        }
        else {
            self.emptyDataImageView.hidden = NO;
            self.emptyDataLabel.hidden = NO;
            self.tablaCupones.hidden = YES;
        }
    }
    viewAppeared = YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor lighterGrayColor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _listaCupones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CuponesTableViewCell"];
    UILabel *labelTitulo = (UILabel *)[cell viewWithTag:100];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        Anuncios *anuncio = [_listaCupones objectAtIndex:indexPath.row];
        labelTitulo.text = anuncio.titulo;
        UIImage *imagen = [[UIImage alloc] initWithData:anuncio.media];
        imgView.image = imagen;
    }else{
        NSDictionary *dk = [_listaCupones objectAtIndex:indexPath.row];
        NSLog(@"%@",dk);
        labelTitulo.text = [dk valueForKey:@"Titulo"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        Anuncios *anuncio = [_listaCupones objectAtIndex:indexPath.row];
        GFKInterface *interface =[NSClassFromString(@"GFKInterface") sharedGFKInterface];
        
        [self presentViewController:[interface viewControllerPara:anuncio] animated:YES completion:^{
            
        }];
    }else{
        NSDictionary *dk = [_listaCupones objectAtIndex:indexPath.row];
        PromocionGeoViewController *pgvc = [[PromocionGeoViewController alloc] initWithNibName:@"PromocionGeoViewController" bundle:nil];
        [pgvc setFaroInfo:dk];
        
        [self presentViewController:pgvc animated:YES completion:^{
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning CuponesVC");
}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        //Do what you intend to do
    } else if(central.state == CBCentralManagerStatePoweredOff) {
        //Bluetooth is disabled. ios pops-up an alert automatically
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Bluetooth está desactivado" andMessage:@"Para recibir tus cupones necesitas tener el Bluetooth encendido"];
        
        [alertView addButtonWithTitle:@"Cerrar"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
}

@end
