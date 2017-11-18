//
// JKHTTPLogger.m
// Pods
//
// Created by Mudox on 12/06/2017.
//
//

#import "JKHTTPLogger.h"

@implementation JKHTTPLogger

typedef void (^DataTaskCompletionHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

#pragma mark singleton URL session

static NSURLSession * s_urlSession = nil;

+ (NSURLSession *)urlSession
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration * config = NSURLSessionConfiguration.defaultSessionConfiguration;
    s_urlSession = [NSURLSession sessionWithConfiguration:config];
  });

  return s_urlSession;
}

#pragma mark singleton data task completion handler

static DataTaskCompletionHandler s_dataTaskComletionHandler = nil;

+ (DataTaskCompletionHandler)dataTaskCompletionHandler
{
  if ([NSProcessInfo.processInfo.environment objectForKey:@"JACK_DEBUG"] == nil)
  {
    return nil;
  }

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    s_dataTaskComletionHandler = ^(NSData * data, NSURLResponse * response, NSError * error)
    {
      // check error
      if (error != nil)
      {
        NSLog(@"JKHTTPLogger] error logging: %@", error);
        return;
      }
      // check reponse status code
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      if (httpResponse == nil && httpResponse.statusCode != 200)
      {
        NSLog(@"JKHTTPLogger] invalid response: %@", httpResponse);
        return;
      }
    };
  });

  return s_dataTaskComletionHandler;
}

#pragma mark DDLogger protocol

- (NSData *)dataWithLogMessage: (DDLogMessage *)logMessage {
  // timestamp as time interval since 1970
  NSNumber *timestamp = @([logMessage->_timestamp timeIntervalSince1970]);


  // level as NSString
  NSString* levelString;
  switch (logMessage->_flag)
  {
  case DDLogFlagError:
    levelString = @"ERROR";
    break;

  case DDLogFlagWarning:
    levelString = @"Warning";
    break;

  case DDLogFlagInfo:
    levelString = @"Info";
    break;

  case DDLogFlagDebug:
    levelString = @"DEBUG";
    break;

  case DDLogFlagVerbose:
    levelString = @"VERBOSE";
    break;
  }

  // subsystem
  NSString *subsystem;

  // message body
  NSString *messageBody;

  NSDictionary *jsonDict = @{
    @"timestamp": timestamp,
    @"level": levelString,
    @"subsystem": subsystem,
    @"message": messageBody,
  };

  NSError *error;
  NSData  *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
  if (error != nil)
  {
    NSLog(@"JKHTTPLogger] error encoding LogMessage into JSON data: %@", error);
    return nil;
  }

  return data;
}

- (void)logMessage: (DDLogMessage *)logMessage {
  // request payload
  NSString *logLine = [self->_logFormatter formatLogMessage:logMessage];
  NSData   *logData = [logLine dataUsingEncoding:NSUTF8StringEncoding];

  // request
  NSURL               *url     = [NSURL URLWithString:@"http://localhost:1888"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  // method
  request.HTTPMethod = @"PUT";
  // header
  [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  // body
  request.HTTPBody = logData;

  NSURLSession *session = NSURLSession.sharedSession;

  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:[JKHTTPLogger dataTaskCompletionHandler]];
  [task resume];
}

- (NSString *)loggerName
{
  return @"com.Mudox.Jack.httpServer";
}

@end
