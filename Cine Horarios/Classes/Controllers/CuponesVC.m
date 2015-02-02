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

@interface CuponesVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablaCupones;

@property (nonatomic,strong) NSMutableArray *listaCupones;

@end

@implementation CuponesVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        GFKInterface *interface =[NSClassFromString(@"GFKInterface") sharedGFKInterface];
        _listaCupones = [[NSMutableArray alloc] initWithArray:[interface listaAnunciosGuardados]];
        [_tablaCupones reloadData];
    }else{
        
        Geofaro *miGeofaro = [Geofaro sharedGeofaro];
        _listaCupones = [[NSMutableArray alloc] initWithArray:[miGeofaro promociones]];
        [_tablaCupones reloadData];
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [_tablaCupones reloadData];
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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        Anuncios *anuncio = [_listaCupones objectAtIndex:indexPath.row];
        labelTitulo.text = anuncio.titulo;
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

@end
