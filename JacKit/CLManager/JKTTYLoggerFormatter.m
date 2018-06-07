@import Foundation;

#import "JKTTYLoggerFormatter.h"

@implementation JKTTYLoggerFormatter

- (NSString *)formatLogMessage: (DDLogMessage *)logMessage
{

  NSString *levelPrefix;

  switch (logMessage.flag)
  {
  case DDLogFlagError:
    levelPrefix = @"💔";
    break;

  case DDLogFlagWarning:
    levelPrefix = @"💜";
    break;

  case DDLogFlagInfo:
    levelPrefix = @"💛";
    break;

  case DDLogFlagDebug:
    levelPrefix = @"💚";
    break;

  case DDLogFlagVerbose:
    levelPrefix = @"🖤";
    break;

  default:
    NSAssert(false, @"Should not be here");
  }

  // subsystem & message
  NSArray  *subsystemAndMessage = [logMessage.message componentsSeparatedByString:@"\v"];
  NSString *subsystem;
  NSString *message;
  if (subsystemAndMessage.count > 1)
  {
    subsystem = subsystemAndMessage[0];
    message   = subsystemAndMessage[1];
  }
  else
  {
    subsystem = [NSString stringWithFormat:@"%@.%@ (fallback)", logMessage.fileName, logMessage.function];
    message   = logMessage.message;
  }

  NSString *msg = [NSString stringWithFormat:@"%@ %@\n%@", levelPrefix, subsystem, message];
  return [msg stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
}

@end


