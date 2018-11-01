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
            levelIcon = @"💙"; break;
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

    // scope
    NSString * scope, * location, * message;
    scope = jsonObject[@"scope"];
    scope = [NSString stringWithFormat:@"[%@]", scope];

    // location
    location = [NSString stringWithFormat:@"▹ %@・%@", jsonObject[@"filename"], jsonObject[@"lineno"]];

    // message text body
    message = jsonObject[@"message"];

    int options = [jsonObject[@"options"] intValue];
    int noLevelIcon = 1 << 0;
    int noLocation = 1 << 1;
    int noScope = 1 << 2;
    int compact = 1 << 3;

    NSString * text = nil;

    if (options == noLevelIcon) {
        text = [NSString stringWithFormat:@"%@\n%@\n%@", scope, message, location];
    } else if (options == (noLevelIcon | compact)) {
        text = [NSString stringWithFormat:@"%@   %@\n%@", scope, message, location];
    } else if (options == noLocation) {
        text = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, scope, message];
    } else if (options == (noLocation | compact)) {
        text = [NSString stringWithFormat:@"%@ %@   %@", levelIcon, scope, message];
    } else if (options == noScope) {
        text = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, message, location];
    } else if (options == (noScope | compact)) {
        text = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, message, location];
    } else if (options == (noLevelIcon | noLocation)) {
        text = [NSString stringWithFormat:@"%@\n%@", scope, message];
    } else if (options == (noLevelIcon | noLocation | compact)) {
        text = [NSString stringWithFormat:@"%@   %@", scope, message];
    } else if (options == (noLevelIcon | noLocation | noScope)) {
        text = [NSString stringWithFormat:@"%@", message];
    } else if (options == (noLevelIcon | noLocation | noScope | compact)) {
        text = [NSString stringWithFormat:@"%@", message];
    } else if (options == compact) {
        text = [NSString stringWithFormat:@"%@ %@   %@\n%@", levelIcon, scope, message, location];
    } else { // Fallback
        text = [NSString stringWithFormat:@"%@ %@\n%@\n%@", levelIcon, scope, message, location];
    }

    // Indent following lines
    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
}

@end


