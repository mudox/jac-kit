#import "JKLogFormatter.h"

@implementation JKLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

  NSString *levelPrefix;

  switch (logMessage.flag) {
  case DDLogFlagError:
    levelPrefix = @"E"; break;
  case DDLogFlagWarning:
    levelPrefix = @"W"; break;
  case DDLogFlagInfo:
    levelPrefix = @"I"; break;
  case DDLogFlagDebug:
    levelPrefix = @"D"; break;
  case DDLogFlagVerbose:
    levelPrefix = @"V"; break;
  default:
    NSAssert(false, @"Should not be here");
  }

  return [NSString stringWithFormat:@"%@| %@", levelPrefix, logMessage.message];
}

@end
