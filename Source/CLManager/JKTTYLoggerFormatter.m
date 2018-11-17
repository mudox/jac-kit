@import Foundation;

#import "JKTTYLoggerFormatter.h"

// Must be sync with `Jack.Options`
enum {
    noIcon = 1 << 0,
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
            icon = (env[@"JACKIT_INFO_ICON"] != nil) ? env[@"JACKIT_INFO_ICON"] : @"💛";
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

    //
    //
    // Step 1 - Extract components
    //
    //

    // Icon
    NSString * icon = iconForFlag(logMessage.flag);
    assert(icon != nil);


    // Transform logMessage.message -> deserialized JSON object
    NSData * jsonData = [logMessage.message dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    assert(error == nil);
    if (error != nil) {
        return [NSString stringWithFormat:@"JKTTYHttpFormatter json deserialization error: %@", error.description];
    }

    // Scope
    NSString * scope, * location, * message;
    scope = jsonObject[@"scope"];
    assert(scope != nil);
    scope = [scope stringByReplacingOccurrencesOfString:@"." withString:@"・"];
    scope = [NSString stringWithFormat:@"%@", scope];

    // Location
    location = [NSString stringWithFormat:@"▹ %@・%@・%@", jsonObject[@"file"], jsonObject[@"function"], jsonObject[@"line"]];

    // Message text
    message = jsonObject[@"message"];
    assert(message != nil);

    /*
     *
     * Step 2 - Assemble messsage according to formatting options
     *
     */

    assert(jsonObject[@"format"] != nil);
    int format = [jsonObject[@"format"] intValue];

    NSString * formatted = nil;

    switch (format) {
        case noIcon:
            formatted = [NSString stringWithFormat:@"%@\n%@\n%@", scope, message, location];
            break;
        case noIcon | compact:
            formatted = [NSString stringWithFormat:@"%@ - %@\n%@", scope, message, location];
            break;
        case  noLocation:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", icon, scope, message];
            break;
        case  noLocation | compact:
            formatted = [NSString stringWithFormat:@"%@ %@ - %@", icon, scope, message];
            break;
        case  noScope:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", icon, message, location];
            break;
        case  noScope | compact:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@", icon, message, location];
            break;
        case  noIcon | noLocation:
            formatted = [NSString stringWithFormat:@"%@\n%@", scope, message];
            break;
        case  noIcon | noLocation | compact:
            formatted = [NSString stringWithFormat:@"%@ - %@", scope, message];
            break;
        case  noIcon | noLocation | noScope:
            formatted = [NSString stringWithFormat:@"%@", message];
            break;
        case  noIcon | noLocation | noScope | compact:
            formatted = [NSString stringWithFormat:@"%@", message];
            break;
        case  compact:
            formatted = [NSString stringWithFormat:@"%@ %@ - %@\n%@", icon, scope, message, location];
        default:
            formatted = [NSString stringWithFormat:@"%@ %@\n%@\n%@", icon, scope, message, location];
    }

    // Indent following lines
    return [formatted stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
}

@end


