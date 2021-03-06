//
// JKHTTPLogger.m
// Pods
//
// Created by Mudox on 12/06/2017.
//
//

#import "JKHTTPLogger.h"
#import "CLManager.h"

static NSURL * serverURL;
static NSURL * eventURL;
static NSURL * sessionURL;
static NSString * sessionIdentifier;

static BOOL _isDebugging;

@implementation JKHTTPLogger {
    NSURLSession * _urlSession;
}

#pragma mark - Class Properties

+ (NSURL *)serverURL {
    return serverURL;
}

+ (NSString *)sessionIdentifier {
    return sessionIdentifier;
}

#pragma mark - Initialization

+ (void)initialize {
    // Only once
    if (self.class != JKHTTPLogger.self) {
        return;
    }

    _isDebugging = ([NSProcessInfo.processInfo.environment[@"JACKIT_DEBUG"] isEqualToString:@"enable"]);

    // Session id = Bundle id + Timestamp
    NSString * bundleID         = NSBundle.mainBundle.bundleIdentifier;
    NSTimeInterval sessionTimestamp = [NSDate.date timeIntervalSince1970];
    sessionIdentifier = [NSString stringWithFormat:@"%@-%f", bundleID, sessionTimestamp];

    [self.class setupURLs];
}

+ (void)setupURLs {
    NSString * urlString = NSProcessInfo.processInfo.environment[@"JAC_SRV_URL"];

    if (nil == urlString) {
        return;
    }

    NSURL * url = [NSURL URLWithString:urlString];
    if (nil == url) {
        NSString * errorLines =
            [@[@"⚠️ JacKit initialization warning",
               [NSString stringWithFormat:@"⚠️ Environment variable `JAC_SRV_URL`s value `%@` is not a valid URL address string", urlString],
               @"⚠️ The `JKHTTPLogger` will not be installed",
             ] componentsJoinedByString: @"\n"];
        TTYLog(@"%@\n\n", errorLines);
        return;
    }

    // Other URLs
    serverURL  = url;
    eventURL   = [self.class.serverURL URLByAppendingPathComponent:@"event" isDirectory:YES];
    sessionURL = [self.class.serverURL URLByAppendingPathComponent:@"session" isDirectory:YES];
}

- (instancetype)init {
    if (nil == self.class.serverURL) {
        return nil;
    }

    if (nil == (self = [super init])) {
        return nil;
    }

    return self;
}

#pragma mark - Private Methods

- (NSData *)requestBodyDataWithLogMessage:(DDLogMessage *)logMessage {
    // timestamp
    // transfer date into Unix time (time since epoch time)
    NSNumber * timestamp = @([logMessage.timestamp timeIntervalSince1970]);

    // level
    NSString * level;

    switch (logMessage.flag) {
        case DDLogFlagError:
            level = @"error";
            break;

        case DDLogFlagWarning:
            level = @"warning";
            break;

        case DDLogFlagInfo:
            level = @"info";
            break;

        case DDLogFlagDebug:
            level = @"debug";
            break;

        case DDLogFlagVerbose:
            level = @"verbose";
            break;
    }

    // subsystem & message
    NSArray * subsystemAndMessage = [logMessage.message componentsSeparatedByString:@"\v"];
    NSString * subsystem;
    NSString * message;
    if (subsystemAndMessage.count > 1) {
        subsystem = subsystemAndMessage[0];
        message   = subsystemAndMessage[1];
    } else {
        subsystem = [NSString stringWithFormat:@"%@.%@ (fallback)", logMessage.fileName, logMessage.function];
        message   = logMessage.message;
    }

    NSDictionary * jsonDict = @{
        @"sessionID": sessionIdentifier,
        @"timestamp": timestamp,
        @"level": level,
        @"subsystem": subsystem,
        @"message": message,
    };

    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    if (error != nil) {
        TTYLog(@"JKHTTPLogger - error JSON encoding event message: %@", error);
        return nil;
    }

    return data;
}

- (void)postGreetingMessage {
    NSDictionary * sessionInfo = @{
        @"bundleID": NSBundle.mainBundle.bundleIdentifier,
        @"timestamp": @([NSDate.date timeIntervalSince1970]),
        @"greeting": CLManager.greetings
    };

    NSError * error;
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:sessionInfo options:kNilOptions error:&error];

    if (error != nil) {
        TTYLog(@"JKHTTPLogger - error JSON encoding session message: %@", error);
        return;
    }

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:sessionURL];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = bodyData;


    NSURLSessionDataTask * task;
    if (_isDebugging) {
        task =
            [_urlSession dataTaskWithRequest:request
                           completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
             {
                 // check error
                 if (error != nil) {
                     TTYLog(@"\n💀 JKHTTPLogger - error sending request: %@\n\n", error);
                     return;
                 }
                 // check reponse status code
                 NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
                 assert(httpResponse != nil);
                 if (httpResponse.statusCode != 200) {
                     TTYLog(@"JKHTTPLogger - invalid response: %@", httpResponse);
                     return;
                 }
             }];
    } else {
        task = [_urlSession dataTaskWithRequest:request];
    }

    [task resume];
}

#pragma mark DDLogger protocol

- (void)logMessage:(DDLogMessage *)logMessage {
    NSData * bodyData = [self requestBodyDataWithLogMessage:logMessage];

    if (nil == bodyData) {
        return;
    }

    // make request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:eventURL];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = bodyData;

    NSURLSessionDataTask * task;
    if (_isDebugging) {
        task =
            [_urlSession dataTaskWithRequest:request
                           completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
             {
                 // check error
                 if (error != nil) {
                     TTYLog(@"\n💀 JKHTTPLogger - error sending request: %@\n\n", error);
                     return;
                 }
                 // check reponse status code
                 NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
                 assert(httpResponse != nil);
                 if (httpResponse.statusCode != 200) {
                     TTYLog(@"JKHTTPLogger - invalid response: %@", httpResponse);
                     return;
                 }
             }];
    } else {
        task = [_urlSession dataTaskWithRequest:request];
    }

    [task resume];
}

- (NSString *)loggerName {
    return @"io.github.muodx.JacKit.JKHTTPLogger";
}

- (void)didAddLogger {
    // create URL session
    NSURLSessionConfiguration * config = NSURLSessionConfiguration.defaultSessionConfiguration;

    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    config.URLCache = nil;
    _urlSession = [NSURLSession sessionWithConfiguration:config];

    [self postGreetingMessage];
}

- (void)willRemoveLogger {
    // cancel all requests & destroy URL session
    [_urlSession invalidateAndCancel];
    _urlSession = nil;
}

@end
