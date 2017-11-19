#import "JacKit.h"
#import "JKLogFormatter.h"
#import "JKHTTPLogger.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif


@implementation Jack

//+ (void)load
//{
//  [self wakeup];
//}

+ (void)wakeup
{
  JKLogFormatter *logFormatter = [JKLogFormatter new];

  /**
   *  Log goes into Xcode debug area / or temrinal when project is run in terminal
   */
  DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
  ttyLogger.logFormatter = logFormatter;
  [DDLog addLogger:ttyLogger];

  /**
   *  Log goes out to the HTTP log server
   */
  JKHTTPLogger *httpLogger = [JKHTTPLogger new];
  [DDLog addLogger:httpLogger];
}

+ (void)greet
{
  NSString *format = [
    @[
      @"\nJacKit initialized\0attached loggers:",
      @"%@",
      @"\n",
    ] componentsJoinedByString: @"\n"];

  NSMutableArray *loggerList = [NSMutableArray array];
  [DDLog.allLoggers enumerateObjectsUsingBlock:^(id < DDLogger > _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     [loggerList addObject:[NSString stringWithFormat:@" [%ld] - %@", (long)idx + 1, obj.loggerName]];
   }];

  NSString *loggerLines = [loggerList componentsJoinedByString:@"\n"];

  DDLogInfo(format, loggerLines);
}

@end

