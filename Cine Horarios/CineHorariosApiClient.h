
#import "AFHTTPSessionManager.h"


static NSString * const kCineHorariosAPIBaseURLString = @"http://cinehorarios.cl/";
static NSString * const kCineHorariosAPIVersion = @"2";
static NSString * const kCineHorariosAPIToken = @"31bfc005557fcccd2728d5710ce3f31f";

@interface CineHorariosApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
