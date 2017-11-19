//
// JKHTTPLogger.m
// Pods
//
// Created by Mudox on 12/06/2017.
//
//

#import "JKHTTPLogger.h"
#import "JacKit.h"

static NSURL *eventURL;
static NSURL *sessionURL;
static NSString *sessionID;

@implementation JKHTTPLogger {
  NSURLSession *_urlSession;
}

+ (void)load
{
  // sessionID
  NSString      *bundleID         = NSBundle.mainBundle.bundleIdentifier;
  NSTimeInterval sessionTimestamp = [NSDate.date timeIntervalSince1970];
  sessionID = [NSString stringWithFormat:@"%@-%f", bundleID, sessionTimestamp];

  // eventURL & sessionURL
  NSURL *baseURL = [NSURL URLWithString:NSProcessInfo.processInfo.environment[@"JACKIT_SERVER_URL"]];
  eventURL   = [baseURL URLByAppendingPathComponent:@"event" isDirectory:YES];
  sessionURL = [baseURL URLByAppendingPathComponent:@"session" isDirectory:YES];
}

- (NSData *)requestBodyDataWithLogMessage: (DDLogMessage *)logMessage
{
  // timestamp
  // transfer date into Unix time (time since epoch time)
  NSNumber *timestamp = @([logMessage.timestamp timeIntervalSince1970]);

  // level
  NSString* level;
  switch (logMessage.flag)
  {
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
  NSArray  *subsystemAndMessage = [logMessage.message componentsSeparatedByString:@"\0"];
  NSString *subsystem           = subsystemAndMessage[0];
  NSString *message             = subsystemAndMessage[1];

  NSDictionary *jsonDict = @{
    @"sessionID": sessionID,
    @"timestamp": timestamp,
    @"level": level,
    @"subsystem": subsystem,
    @"message": message,
  };

  NSError *error;
  NSData  *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
  if (error != nil)
  {
    NSLog(@"JKHTTPLogger - error JSON encoding event message: %@", error);
    return nil;
  }

  return data;
}

- (void)postInitiatingMessage
{
  NSDictionary *sessionInfo= @{
    @"bundleID": NSBundle.mainBundle.bundleIdentifier,
    @"timestamp": @([NSDate.date timeIntervalSince1970])
  };

  NSError *error;
  NSData  *bodyData = [NSJSONSerialization dataWithJSONObject:sessionInfo options:kNilOptions error:&error];
  if (error != nil)
  {
    NSLog(@"JKHTTPLogger - error JSON encoding session message: %@", error);
    return;
  }

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sessionURL];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  request.HTTPBody = bodyData;

#ifdef JACKIT_DEBUG
  NSURLSessionDataTask *task =
    [_urlSession dataTaskWithRequest:request
                   completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
     {
       // check error
       if (error != nil)
       {
         NSLog(@"JKHTTPLogger - error sending request: %@", error);
         return;
       }
       // check reponse status code
       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
       NSAssert(httpResponse != nil)
       if (httpResponse.statusCode != 200)
       {
         NSLog(@"JKHTTPLogger - invalid response: %@", httpResponse);
         return;
       }
     }];
#else
  NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest:request];
#endif
  [task resume];
}

#pragma mark DDLogger protocol

- (void)logMessage: (DDLogMessage *)logMessage
{
  NSData *bodyData = [self requestBodyDataWithLogMessage:logMessage];
  if (nil == bodyData)
  {
    return;
  }

  // make request
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:eventURL];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  request.HTTPBody = bodyData;

#ifdef JACKIT_DEBUG
  NSURLSessionDataTask *task =
    [_urlSession dataTaskWithRequest:request
                   completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
     {
       // check error
       if (error != nil)
       {
         NSLog(@"JKHTTPLogger - error sending request: %@", error);
         return;
       }
       // check reponse status code
       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
       NSAssert(httpResponse != nil)
       if (httpResponse.statusCode != 200)
       {
         NSLog(@"JKHTTPLogger - invalid response: %@", httpResponse);
         return;
       }
     }];
#else
  NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest:request];
#endif
  [task resume];
}

- (NSString *)loggerName
{
  return @"io.github.muodx.JacKit.JKHTTPLogger";
}

- (void)didAddLogger
{
  // create URL session
  NSURLSessionConfiguration * config = NSURLSessionConfiguration.defaultSessionConfiguration;
  _urlSession = [NSURLSession sessionWithConfiguration:config];

  [self postInitiatingMessage];
}

- (void)willRemoveLogger
{
  // cancel all requests & destroy URL session
  [_urlSession invalidateAndCancel];
  _urlSession = nil;
}


@end










