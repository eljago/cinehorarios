//
//  ArchivoManagerFaro.h
//  
//
//  Created by Informática Spock on 30-07-12.
//
//
#import <CoreBluetooth/CoreBluetooth.h>

@class ArchivoManagerFaro;
@interface ArchivoManagerFaro : NSObject

@property (nonatomic,strong) NSString *tipo;
@property (nonatomic) int tag;

+ (ArchivoManagerFaro *)sharedArchivoManagerFaro;

- (void)guardarTexto:(NSString*)texto nombreArchivo:(NSString*)nombreArchivo;
- (void)guardarData:(NSData*)data nombreArchivo:(NSString*)nombreArchivo;


- (NSString*)obtenerContenidoDeRuta:(NSString*)ruta nombreArchivo:(NSString*)nombreArchivo;
- (NSData*)obtenerDataDeRuta:(NSString*)ruta nombreArchivo:(NSString*)nombreArchivo;

- (NSString*)rutaDirectorios;
- (NSMutableArray*)listarNombreArchivos;
- (NSMutableArray*)listarArchivosContenido;
- (NSMutableArray*)listarArchivosPrefijo:(NSString*)prefijo;

- (NSString*)obtenerNombreArchivoDeRuta:(NSString*)ruta;
- (NSString*)obtenerTipoArchivoDeRuta:(NSString*)ruta;

- (void)borrarArchivoRuta:(NSString*)ruta;
- (BOOL)borrarCarpetaNombre:(NSString *)nombre;

- (BOOL)revisarFaro:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;
- (BOOL)guardarFaro:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;
- (NSMutableArray*)obtenerFarosDeArchivo:(NSString*)archivo;
- (NSMutableDictionary*)obtenerFaroGuardado:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;

#pragma mark - Conversiones

- (NSString*)identificadorToServicio:(NSString *)identificador;
- (NSString*)identificadorToNombre:(NSString *)identificador;

- (NSString*)servicioToNombre:(NSString *)servicio;
- (NSString*)servicioToIdentificador:(NSString*)servicio;

- (NSString *)uuidToServicio:(CBUUID*)uuid;

#pragma mark - Obtener los faros

- (NSMutableArray*)getFarosVistos;
- (NSMutableArray*)getFarosNoEnviados;
- (NSMutableArray*)getFarosGuardados;
- (NSMutableArray*)getFarosPromociones;

@end