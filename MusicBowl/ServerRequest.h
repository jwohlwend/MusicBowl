//
//  ServerRequest.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ServerRequest : NSObject
{
    @private NSString* type;
    @private NSString* url;
    @private NSError* error;
    @private NSDictionary* response;
    @private NSMutableDictionary* parameters;
    @private dispatch_semaphore_t semaphore;
}

- (NSString*) type;
- (NSString*) url;
- (NSDictionary*) response;
- (NSError*) error;
- (NSMutableDictionary*) parameters;
- (dispatch_semaphore_t) semaphore;
- (id) initWithType:(NSString *) requestType;
- (void) setType:(NSString*) requestType;
- (void) setUrl:(NSString*) requestURL;
- (void) setError:(NSError*) requestError;
- (void) setResponse: (NSDictionary*) responseDict;
- (void) setSemaphore: (dispatch_semaphore_t) sem;
- (void) setParameters:(NSMutableDictionary*) parametersDict;
- (void) addParameter:(NSString *)key withValue:(NSObject *)value;
- (void) start;
- (void) synchronize;
- (NSError*) getError;
- (NSDictionary*) getResponse;
- (void) handleError:(NSError*) error withVC:(id) vc;

@end
