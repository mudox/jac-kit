#import "JacKit.h"
#import "JKLogFormatter.h"
#import "JKFileManager.h"
#import "JKHTTPLogger.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif


@implementation Jack

/**
   No need cal it manually any more
 */
+ (void)load
{
  [self wakeup];
}

/**
 *  Call it once typically in AppDelegate.m applcation:didFinishedLaunching... method.
 */
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
   *  Log goes out to a log file (only when run on simulator)
   */
#if TARGET_IPHONE_SIMULATOR
  DDLogFileManagerDefault *defaultLogFileManager = [[JKFileManager alloc] initWithLogsDirectory:@"/tmp/mudox/log/Xcode/Jack"];
  DDFileLogger            *fileLogger            = [[DDFileLogger alloc] initWithLogFileManager:defaultLogFileManager];
  fileLogger.logFormatter = logFormatter;
  [DDLog addLogger:fileLogger];
#endif

  /**
   *  Log goes out to the HTTP log server
   */
  JKHTTPLogger *httpLogger = [JKHTTPLogger new];
  [DDLog addLogger:httpLogger];

/**
 *  Log gose through the new Unified Logging system
 */
// JackOSLogger *osLogger = JackOSLogger.sharedInstance;
// osLogger.logFormatter = logFormatter;
// [DDLog addLogger:osLogger];

  [self greet];
}

+ (void)greet
{
  NSString *lines = [
    @[
      @"Jack] initialized",
      @">> attached loggers:",
      @"%@",
      @"\n",
    ] componentsJoinedByString: @"\n"];

  NSMutableArray *loggerList = [NSMutableArray array];
  [DDLog.allLoggers enumerateObjectsUsingBlock:^(id < DDLogger > _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     [loggerList addObject:[NSString stringWithFormat:@">>    [%ld] - %@", (long)idx + 1, obj.loggerName]];
   }];

  NSString *loggers = [loggerList componentsJoinedByString:@"\n"];

  DDLogInfo(lines, loggers);
}

@end
