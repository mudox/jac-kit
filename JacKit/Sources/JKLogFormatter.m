#import "JKLogFormatter.h"

@implementation JKLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

  NSString *levelPrefix;

  switch (logMessage.flag)
  {
  case DDLogFlagError:
    levelPrefix = @"⁉️";
    break;

  case DDLogFlagWarning:
    levelPrefix = @"⚠️";
    break;

  case DDLogFlagInfo:
    levelPrefix = @"🔆";
    break;

  case DDLogFlagDebug:
    levelPrefix = @"🔎";
    break;

  case DDLogFlagVerbose:
    levelPrefix = @"▫️";
    break;

  default:
    NSAssert(false, @"Should not be here");
  }

  return [NSString stringWithFormat:@"%@| %@", levelPrefix, logMessage.message];
}

@end
