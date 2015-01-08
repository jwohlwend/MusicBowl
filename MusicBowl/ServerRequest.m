//
//  ServerRequest.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest


- (id)initWithType:(NSString *) requestType
{
    self = [super init];
    if (self){
        self.type = requestType;
        self.url = @"http://192.168.1.50:6680/mopidy/rpc";
        self.parameters = [[NSMutableDictionary alloc] init];
        self.semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (NSString*) type{
    return type;
}

- (NSString*) url{
    return url;
}

- (NSDictionary*) response{
    return response;
}

- (NSError*) error{
    return error;
}
- (dispatch_semaphore_t) semaphore{
    return semaphore;
}
    
- (NSMutableDictionary*) parameters{
    return parameters;
}
- (void) setType: (NSString*) requestType{
    type = requestType;
}
- (void) setUrl: (NSString*) requestURL{
    url = requestURL;
}
- (void) setResponse: (NSDictionary*) responseDict{
    response = responseDict;
}

- (void) setError: (NSError*) requestError{
    error = requestError;
}
- (void) setParameters: (NSMutableDictionary*) parametersDict{
    parameters = parametersDict;
}
- (void) setSemaphore: (dispatch_semaphore_t) sem{
    semaphore = sem;
}
- (void) addParameter:(NSString *)key withValue:(NSObject *)value{
    [self.parameters setValue:value forKey:key];
}

- (void) start{
    [self addParameter:@"jsonrpc" withValue:@"2.0"];
    [self addParameter:@"id" withValue:[NSNumber numberWithInt:1]];
    [self addParameter:@"method" withValue:self.type];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager POST:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.response = (NSDictionary *)responseObject[@"result"];
        //NSLog(@"%@", responseObject);
        dispatch_semaphore_signal(self.semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError*requestError) {
        self.error = requestError;
        dispatch_semaphore_signal(self.semaphore);
    }];
}

- (void) synchronize{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (NSDictionary*) getResponse{
    return self.response;
}

- (NSError*) getError{
    return self.error;
}



- (void) handleError:(NSError*) theError withVC:(id) vc{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:[theError localizedFailureReason]
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [vc presentViewController:alert animated:YES completion:nil];
}


@end
