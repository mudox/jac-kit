@import Foundation;

#define JackError(content, ...)     DDLogError(@"%@ %@] " content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackInfo(content, ...)      DDLogInfo(@"%@ %@] " content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackWarn(content, ...)      DDLogWarn(@"%@ %@] " content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackDebug(content, ...)     DDLogDebug(@"%@ %@] " content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackVerbose(content, ...)   DDLogVerbose(@"%@ %@] " content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)

#define BOOLSTR(b) (( (b) ? @"YES" : @"NO" ))
#define BOOLSYMBOL(b) (( (b) ? @"✓" : @"✗" ))

@interface Jack : NSObject

+ (void)wakeup;

@end
