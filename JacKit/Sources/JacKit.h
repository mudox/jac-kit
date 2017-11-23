@import Foundation;

#define BOOLSTR(b) (( (b) ? @"YES" : @"NO" ))
#define BOOLSYMBOL(b) (( (b) ? @"✓" : @"✗" ))

#define JackError(content, ...)     DDLogError(@"%@ %@\0" content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackInfo(content, ...)      DDLogInfo(@"%@ %@\0" content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackWarn(content, ...)      DDLogWarn(@"%@ %@\0" content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackDebug(content, ...)     DDLogDebug(@"%@ %@\0" content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackVerbose(content, ...)   DDLogVerbose(@"%@ %@\0" content, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)

#define JackErrorWithPrefix(prefix, content, ...)     DDLogError(@"%@\0" content, prefix, ## __VA_ARGS__)
#define JackInfoWithPrefix(prefix, content, ...)      DDLogInfo(@"%@\0" content, prefix, ## __VA_ARGS__)
#define JackWarnWithPrefix(prefix, content, ...)      DDLogWarn(@"%@\0" content, prefix, ## __VA_ARGS__)
#define JackDebugWithPrefix(prefix, content, ...)     DDLogDebug(@"%@\0" content, prefix, ## __VA_ARGS__)
#define JackVerboseWithPrefix(prefix, content, ...)   DDLogVerbose(@"%@\0" content, prefix, ## __VA_ARGS__)

// used internally to log directly to terminal
#define TTYLog(args,...) do { [(NSFileHandle*)[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:args, ##__VA_ARGS__] dataUsingEncoding: NSUTF8StringEncoding]]; } while(0);

@interface Jack : NSObject

@property (class, strong, readonly, nonatomic) NSString *greetingString;

+ (void)wakeup;

@end
