#import "CLManager.h"
#import "JKTTYLoggerFormatter.h"
#import "JKHTTPLogger.h"

// #ifdef DEBUG
// static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
// #else
// static const DDLogLevel ddLogLevel = DDLogLevelWarning;
// #endif

static NSString *_greetings;

@implementation CLManager

+ (NSString *)greetings
{
  return _greetings;
}

+ (void)load
{
  [self wakeup];
}

/**
 Create, configure and attach loggers.
 Print initial message.
 */
+ (void)wakeup
{
  NSMutableString *greetingLines = [NSMutableString string];

  /**
   *  Log goes into Xcode debug area or temrinal when project is run in terminal
   */
  DDTTYLogger    *ttyLogger    = [DDTTYLogger sharedInstance];
  JKTTYLoggerFormatter *logFormatter = [JKTTYLoggerFormatter new];
  ttyLogger.logFormatter = logFormatter;

  [greetingLines appendString:[
     @[
       @"    _____                      __    __  __    __",
       @"   |     \\                    |  \\  /  \\|  \\  |  \\",
       @"    \\$$$$$  ______    _______ | $$ /  $$ \\$$ _| $$_",
       @"      | $$ |      \\  /       \\| $$/  $$ |  \\|   $$ \\",
       @" __   | $$  \\$$$$$$\\|  $$$$$$$| $$  $$  | $$ \\$$$$$$",
       @"|  \\  | $$ /      $$| $$      | $$$$$\\  | $$  | $$ __",
       @"| $$__| $$|  $$$$$$$| $$_____ | $$ \\$$\\ | $$  | $$|  \\",
       @" \\$$    $$ \\$$    $$ \\$$     \\| $$  \\$$\\| $$   \\$$  $$",
       @"  \\$$$$$$   \\$$$$$$$  \\$$$$$$$ \\$$   \\$$ \\$$    \\$$$$",
       @"\n\n",
       
       @"[Add TTY Logger]",
       [NSString stringWithFormat:@"  - Logger name:      %@", ttyLogger.loggerName],
       [NSString stringWithFormat:@"  - Logging queue:    %s", dispatch_queue_get_label(ttyLogger.loggerQueue)],
     ] componentsJoinedByString: @"\n"]];

  /**
   *  Log goes out to the JacServer
   */
  JKHTTPLogger *httpLogger = [JKHTTPLogger new];
  if (httpLogger != nil)
  {
    [greetingLines appendString:[
       @[
         @"\n\n[Add HTTP Logger]",
         [NSString stringWithFormat:@"  - Logger name:      %@", httpLogger.loggerName],
         [NSString stringWithFormat:@"  - Logging queue:    %s", dispatch_queue_get_label(httpLogger.loggerQueue)],
         [NSString stringWithFormat:@"  - Server address:   %@", JKHTTPLogger.serverURL],
         [NSString stringWithFormat:@"  - Session ID:       %@", JKHTTPLogger.sessionID],
       ] componentsJoinedByString: @"\n"]];
    _greetings = greetingLines;
  }

  TTYLog(@"\n\n\n%@\n\n\n\n", greetingLines);

  /**
   * Add loggers at the very end, after the `greetingString` property is full initilization
   * JKHttpLogger -didAddLogger will add this property into its first message to the server
   */
  [DDLog addLogger:ttyLogger];
  if (httpLogger != nil) {
    [DDLog addLogger:httpLogger];
  }
}

@end












