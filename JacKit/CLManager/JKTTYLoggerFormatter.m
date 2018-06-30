@import Foundation;

#import "JKTTYLoggerFormatter.h"

@implementation JKTTYLoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

    NSString * levelIcon;

    switch (logMessage.flag) {
        case DDLogFlagError:
            levelIcon = @"💔"; break;
        case DDLogFlagWarning:
            levelIcon = @"💜"; break;
        case DDLogFlagInfo:
            levelIcon = @"💛"; break;
        case DDLogFlagDebug:
            levelIcon = @"💚"; break;
        case DDLogFlagVerbose:
            levelIcon = @"🖤"; break;
        default:
            NSAssert(false, @"Should not be here");
    }

    // subsystem & message
    NSData * jsonData = [logMessage.message dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error != nil) {
        return [NSString stringWithFormat:@"JKTTYHttpFormatter json deserialization error: %@", error.description];
    }

    NSString * scope, * location, * message;
    int options;
    scope = jsonObject[@"scope"];
    location = jsonObject[@"location"];
    message = jsonObject[@"message"];

    options = [jsonObject[@"options"] intValue];
    int noLevelIcon = 1 << 0;
    int noLocation = 1 << 1;
    int noScope = 1 << 2;
  BOOL compact = options & (1 << 3);

    NSString * text;
    if (options == noLevelIcon) {
    text = [NSString stringWithFormat:@"%@\n%@\n%@", scope, message, location];
    } else if (options == noLocation) {
      if (compact) {
        text = [NSString stringWithFormat:@"%@ %@   %@", levelIcon, scope, message];
      } else {
        text = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, scope, message];
      }
    } else if (options == (noLevelIcon | noLocation)) {
      if (compact) {
        text = [NSString stringWithFormat:@"%@   %@", scope, message];
      } else {
        text = [NSString stringWithFormat:@"%@\n%@", scope, message];
      }
    } else if (options == (noLevelIcon | noLocation | noScope)) {
        text = [NSString stringWithFormat:@"%@", message];
    } else {
      if (compact) {
        text = [NSString stringWithFormat:@"%@ %@   %@\n%@", levelIcon, scope, message, location];
      } else {
        text = [NSString stringWithFormat:@"%@ %@\n%@\n%@", levelIcon, scope, message, location];
      }
    }

    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
}

@end


