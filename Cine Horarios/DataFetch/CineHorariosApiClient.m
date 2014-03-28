

#import "CineHorariosApiClient.h"


@implementation CineHorariosApiClient

+ (CineHorariosApiClient *)sharedClient {
    static CineHorariosApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPAdditionalHeaders:@{
                                                  @"Authorization": [NSString stringWithFormat:@"Token token=%@",kCineHorariosAPIToken],
                                                  @"APIV": [NSString stringWithFormat:@"application/cinehorarios.ios.v%@",kCineHorariosAPIVersion]
                                                  }];
        _sharedClient = [[CineHorariosApiClient alloc] initWithBaseURL:[NSURL URLWithString:kCineHorariosAPIBaseURLString] sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}


@end
