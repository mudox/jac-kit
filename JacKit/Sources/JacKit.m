#import "JacKit.h"
#import "JKLogFormatter.h"
#import "JKHTTPLogger.h"

//#ifdef DEBUG
//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
//#else
//static const DDLogLevel ddLogLevel = DDLogLevelWarning;
//#endif

static NSString *greetingString;

@implementation Jack

+ (NSString *)greetingString {
  return greetingString;
}

+ (void)load
{
  [self wakeup];
}

+ (void)wakeup
{
  NSMutableString *greetingLines = [NSMutableString stringWithString:@"JacKit initialized\0"];

  /**
   *  Log goes into Xcode debug area or temrinal when project is run in terminal
   */
  DDTTYLogger    *ttyLogger    = [DDTTYLogger sharedInstance];
  JKLogFormatter *logFormatter = [JKLogFormatter new];
  ttyLogger.logFormatter = logFormatter;
  [DDLog addLogger:ttyLogger];

  [greetingLines appendString:[
     @[
       @"Add TTY Logger\n",
       [NSString stringWithFormat: @"  - Logger name: %@", ttyLogger.loggerName],
       [NSString stringWithFormat: @"  - Logging queue: %s", dispatch_queue_get_label(ttyLogger.loggerQueue)],
     ] componentsJoinedByString: @"\n"]];


  /**
   *  Log goes out to the JacServer
   */
  JKHTTPLogger *httpLogger = [JKHTTPLogger new];
  [DDLog addLogger:httpLogger];

  [greetingLines appendString:[
     @[
       @"Add HTTP Logger\n",
       [NSString stringWithFormat:@"  - Logger name: %@", httpLogger.loggerName],
       [NSString stringWithFormat:@"  - Logging queue: %s", dispatch_queue_get_label(httpLogger.loggerQueue)],
       [NSString stringWithFormat:@"  - Server address: %@", NSProcessInfo.processInfo.environment[@"JACKIT_SERVER_URL"]],
     ] componentsJoinedByString: @"\n"]];
  
  greetingString = greetingLines;
}

@end





