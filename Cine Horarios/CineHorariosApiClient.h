
#import "AFHTTPSessionManager.h"


//static NSString * const kCineHorariosAPIBaseURLString = @"http://cinehorarios.cl/";
static NSString * const kCineHorariosAPIBaseURLString = @"http://localhost:3000/";
static NSString * const kCineHorariosAPIVersion = @"3";
static NSString * const kCineHorariosAPIToken = @"31bfc005557fcccd2728d5710ce3f31f";

@interface CineHorariosApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
