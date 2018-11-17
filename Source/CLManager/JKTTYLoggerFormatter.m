@import Foundation;

#import "JKTTYLoggerFormatter.h"

// Must be sync with `Jack.Options`
enum {
    noLevelIcon = 1 << 0,
    noLocation = 1 << 1,
    noScope = 1 << 2,
    compact = 1 << 3
};

NSString * iconForFlag(DDLogFlag flag) {
    NSDictionary * env = NSProcessInfo.processInfo.environment;
    NSString * icon;

    switch (flag) {
        case DDLogFlagError:
            icon = (env[@"JACKIT_ERROR_ICON"] != nil) ? env[@"JACKIT_ERROR_ICON"] : @"💔";
            break;
        case DDLogFlagWarning:
            icon = (env[@"JACKIT_WARNING_ICON"] != nil) ? env[@"JACKIT_WARNING_ICON"] : @"💜";
            break;
        case DDLogFlagInfo:
            icon = (env[@"JACKIT_INFO_ICON"] != nil) ? env[@"JACINFOKIT_INFO_ICON"] : @"💛";
            break;
        case DDLogFlagDebug:
            icon = (env[@"JACKIT_DEBUG_ICON"] != nil) ? env[@"JACKIT_DEBUG_ICON"] : @"💚";
            break;
        case DDLogFlagVerbose:
            icon = (env[@"JACKIT_VERBOSE_ICON"] != nil) ? env[@"JACKIT_VERBOSE_ICON"] : @"▫️";
            break;
        default:
            icon = @"👽";
            break;
    }

    return icon;
}

@implementation JKTTYLoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

    // Level icon
    NSString * levelIcon = iconForFlag(logMessage.flag);


    // Transform logMessage.message -> deserialized JSON object
    NSData * jsonData = [logMessage.message dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    if (error != nil) {
        return [NSString stringWithFormat:@"JKTTYHttpFormatter json deserialization error: %@", error.description];
    }

    // Scope
    NSString * scope, * location, * message;
    scope = jsonObject[@"scope"];
    scope = [NSString stringWithFormat:@"[%@]", scope];

    // Location
    location = [NSString stringWithFormat:@"▹ %@・%@・%@", jsonObject[@"file"], jsonObject[@"function"], jsonObject[@"line"]];

    // Message text
    message = jsonObject[@"message"];

    /*
     *
     * Step 2 - Assemble messsage according to formatting options
     *
     */

    int options = [jsonObject[@"options"] intValue];

    NSString * formatted = nil;

    switch (options) {
        case noLevelIcon:
            formatted = [NSString stringWithFormat:@"%@\n%@\n%@", scope, message, location];
            break;
        case noLevelIcon | compact:
            formatted = [NSString stringWithFormat:@"%@   %@\n%@", scope, message, location];
            break;
        case  noLocation:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, scope, message];
            break;
        case  noLocation | compact:
            formatted = [NSString stringWithFormat:@"%@ %@   %@", levelIcon, scope, message];
            break;
        case  noScope:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, message, location];
            break;
        case  noScope | compact:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", levelIcon, message, location];
            break;
        case  noLevelIcon | noLocation:
            formatted = [NSString stringWithFormat:@"%@\n%@", scope, message];
            break;
        case  noLevelIcon | noLocation | compact:
            formatted = [NSString stringWithFormat:@"%@   %@", scope, message];
            break;
        case  noLevelIcon | noLocation | noScope:
            formatted = [NSString stringWithFormat:@"%@", message];
            break;
        case  noLevelIcon | noLocation | noScope | compact:
            formatted = [NSString stringWithFormat:@"%@", message];
            break;
        case  compact:
            formatted = [NSString stringWithFormat:@"%@ %@   %@\n%@", levelIcon, scope, message, location];
        default:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@\n%@", levelIcon, scope, message, location];
    }

    // Indent following lines
    return [formatted stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
}

@end


