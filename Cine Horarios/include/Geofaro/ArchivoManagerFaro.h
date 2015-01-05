//
//  ArchivoManagerFaro.h
//  
//
//  Created by Informática Spock on 30-07-12.
//
//
#import <CoreBluetooth/CoreBluetooth.h>

@class ArchivoManagerFaro;
/**
 Clase Helper para trabajar con las conversiones de los faros. También sirve para trabajar con la lectura y escritura de archivos.
 
 Los nombres de los archivos importantes son tomados de constantes definidas en Geofaro-Prefix.pch
 */
@interface ArchivoManagerFaro : NSObject
/**
 *  Tipo de archivo
 */
@property (nonatomic,strong) NSString *tipo;
/**
 *  Tag para diferenciarlo de otras instancias
 */
@property (nonatomic) int tag;
/**
 *  Singleton de la clase
 *
 *  @return Instancia de ArchivoManagerFaro
 */
+ (ArchivoManagerFaro *)sharedArchivoManagerFaro;
/**
 *  Guarda una línea de texto en un archivo de texto en la CarpetaData dentro de Documents
 *
 *  @param texto         texto a guardar en el archivo
 *  @param nombreArchivo nombre del archivo. Debe tener la extensión
 */
- (void)guardarTexto:(NSString*)texto nombreArchivo:(NSString*)nombreArchivo;
/**
 *  Guardar un NSData, imagen, etc. con un nombre de archivo
 *
 *  @param data          NSData a guardar
 *  @param nombreArchivo NSString nombre del archivo
 */
- (void)guardarData:(NSData*)data nombreArchivo:(NSString*)nombreArchivo;
/**
 *  Obtiene el contenido de un archivo de texto local
 *
 *  @param ruta          NSString de la ruta local del archivo
 *  @param nombreArchivo NSString con el nombre del archivo a leer
 *
 *  @return MSString con el contenido
 */
- (NSString*)obtenerContenidoDeRuta:(NSString*)ruta nombreArchivo:(NSString*)nombreArchivo;
/**
 *  Obtiene un NSData de una ruta local
 *
 *  @param ruta          NSString con la ruta local del NSData
 *  @param nombreArchivo NSString con el nombre del archivo a obtener
 *
 *  @return NSData del archivo local
 */
- (NSData*)obtenerDataDeRuta:(NSString*)ruta nombreArchivo:(NSString*)nombreArchivo;
/**
 *  Obtiene la ruta de la carpeta NSDocumentDirectory de la aplicación
 *
 *  @return NSString con la ruta del NSDocumentDirectory
 */
- (NSString*)rutaDirectorios;
/**
 *  Obtiene una lista con todos los nombres de los archivos de NSDocumentDirectory
 *
 *  @return NSMutableArray con los nombres de archivos
 */
- (NSMutableArray*)listarNombreArchivos;
/**
 *  Obtiene una lista con todos los contenidos de los archivos listados con listarNombreArchivos;
 *
 *  @return NSMutableArray con los contenidos de los archivos de texto
 */
- (NSMutableArray*)listarArchivosContenido;
/**
 *  Obtiene una lista de todos los archivos que empiecen con un prefijo de la forma "prefijo-"
 *
 *  @param prefijo NSString del prefijo de los archivos a buscar
 *
 *  @return NSMutableArray con los nombres de archivo
 */
- (NSMutableArray*)listarArchivosPrefijo:(NSString*)prefijo;
/**
 *  Obtiene el nombre de un archivo según una ruta remota
 *
 *  @param ruta NSString de la ruta remota
 *
 *  @return NSString del nombre del archivo remoto
 */
- (NSString*)obtenerNombreArchivoDeRuta:(NSString*)ruta;
/**
 *  Obtiene la extensión de un archivo según una ruta remota
 *
 *  @param ruta NSString de la ruta remota
 *
 *  @return NSString de la extensión
 */
- (NSString*)obtenerTipoArchivoDeRuta:(NSString*)ruta;
/**
 *  Borra un archivo local
 *
 *  @param ruta NSString de la ruta local del archivo
 */
- (void)borrarArchivoRuta:(NSString*)ruta;
/**
 *  Borrar una carpeta local contenido en la rutaDirectorios
 *
 *  @param nombre NSString del nombre de la carpeta
 *
 *  @return BOOL YES si se borró con éxito. NO en caso de error o no existir la carpeta
 */
- (BOOL)borrarCarpetaNombre:(NSString *)nombre;
/**
 *  Revisa si un faro (NSDictionary) está en un archivo de texto específico en rutaDirectorios, CarpetaData de la aplicación
 *
 *  @param faroEncontrado NSDictionary faro
 *  @param archivo        NSString nombre del archivo
 *
 *  @return BOOL YES si fue encontrado. NO en caso contrario
 */
- (BOOL)revisarFaro:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;
/**
 *  Guardar un faro en un archivo de texto en rutaDirectorios, CarpetaData de la aplicación. Los nombres de archivo pueden ser:
 *  FarosGuardados, FarosNoEnviados, FarosEnviados, FarosPromociones
 *  @param faroEncontrado NSDictionary faro
 *  @param archivo        NSString nombre del archivo
 *
 *  @return BOOL YES si se guardó. NO en caso contrario
 */
- (BOOL)guardarFaro:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;
/**
 *  Obtiene una lista de los faros guardados en un archivo en rutaDirectorios, CarpetaData de la aplicación. Los nombres de archivo pueden ser:
 *  FarosGuardados, FarosNoEnviados, FarosEnviados, FarosPromociones
 *  @param archivo NSString con nombre del archivo
 *
 *  @return NSMutableArray con los faros del archivo
 */
- (NSMutableArray*)obtenerFarosDeArchivo:(NSString*)archivo;
/**
 *  Obtiene un NSMutableDictionary de un faro guardado en un archivo en rutaDirectorios, CarpetaData de la aplicación. Los nombres de archivo pueden ser:
 *  FarosGuardados, FarosNoEnviados, FarosEnviados, FarosPromociones
 *
 *  @param faroEncontrado NSDictionary del faro a buscar
 *  @param archivo        NSString con el nombre del archivo.
 *
 *  @return NSMutableDictionary con la información del faro
 */
- (NSMutableDictionary*)obtenerFaroGuardado:(NSDictionary*)faroEncontrado enArchivo:(NSString*)archivo;

#pragma mark - Conversiones
/**
 @abstract Conversor de AA035 a SPKBEAA035
 @deprecated 1.68
 @param identificador NSString con el identificador tipo AA035
 @return NSString con SPKBEAA035
 */
- (NSString*)identificadorToNombre:(NSString *)identificador;
/**
 @abstract Conversor de AA035 a 350E
 @deprecated 1.68
 @param identificador NSString con el identificador tipo AA035
 @return NSString con 350E
 */
- (NSString*)identificadorToServicio:(NSString *)identificador;
/**
 @abstract Conversor de 350E a SPKBEAA035
 @deprecated 1.68
 @param servicio NSString con el servicio tipo 350E
 @return NSString con el nombre SPKBEAA035
 */
- (NSString*)servicioToNombre:(NSString *)servicio;
/**
 @abstract Conversor de 350E a AA035
 @deprecated 1.68
 @param servicio NSString con el servicio tipo 350E
 @return NSString con el identificador AA035
 */
- (NSString*)servicioToIdentificador:(NSString*)servicio;
/**
 *  Conversor CBBUID a NSString. 350E
 *
 *  @param uuid CBBUID del servicio
 *
 *  @return NSString con el servicio 350E
 */
- (NSString*)uuidToServicio:(CBUUID*)uuid;

#pragma mark - Obtener los faros
/**
 *  Devuelve una lista de los FarosEnviados. SIN IMPLEMENTAR
 *
 *  @return NSMutableArray con NSDictionary
 */
- (NSMutableArray*)getFarosEnviados;
/**
 *  Devulve una lista con los FarosNoEnviados por problemas de internet. Al siguiente día o al encontrar un faro se enviarán como un faro pendiente
 *
 *  @return NSMutableArray con NSDictionary
 */
- (NSMutableArray*)getFarosNoEnviados;
/**
 *  Devuelve una lista con los FarosGuardados, los faros que se han visto en algún momento y el servidor respondió.
 *
 *  @return NSMutableArray con NSDictionary
 */
- (NSMutableArray*)getFarosGuardados;
/**
 *  Devuelve una lista con los FarosPromociones, los faros que sí tienen promociones
 * 
 *  @return NSMutableArray con NSDictionary
 */
- (NSMutableArray*)getFarosPromociones;

@end