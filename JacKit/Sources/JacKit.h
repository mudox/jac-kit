@import Foundation;

#define BOOLSTR(b) (( (b) ? @"YES" : @"NO" ))
#define BOOLSYMBOL(b) (( (b) ? @"✓" : @"✗" ))

#define JackError(fmt, ...)     DDLogError(@"%@ %@\0" fmt, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackInfo(fmt, ...)      DDLogInfo(@"%@ %@\0" fmt, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackWarn(fmt, ...)      DDLogWarn(@"%@ %@\0" fmt, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackDebug(fmt, ...)     DDLogDebug(@"%@ %@\0" fmt, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)
#define JackVerbose(fmt, ...)   DDLogVerbose(@"%@ %@\0" fmt, THIS_FILE, THIS_METHOD, ## __VA_ARGS__)

#define JackErrorWithPrefix(prefix, fmt, ...)     DDLogError(@"%@\0" fmt, prefix, ## __VA_ARGS__)
#define JackInfoWithPrefix(prefix, fmt, ...)      DDLogInfo(@"%@\0" fmt, prefix, ## __VA_ARGS__)
#define JackWarnWithPrefix(prefix, fmt, ...)      DDLogWarn(@"%@\0" fmt, prefix, ## __VA_ARGS__)
#define JackDebugWithPrefix(prefix, fmt, ...)     DDLogDebug(@"%@\0" fmt, prefix, ## __VA_ARGS__)
#define JackVerboseWithPrefix(prefix, fmt, ...)   DDLogVerbose(@"%@\0" fmt, prefix, ## __VA_ARGS__)

// used internally to log directly to terminal
#define TTYLog(args,...) do { [(NSFileHandle*)[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:args, ##__VA_ARGS__] dataUsingEncoding: NSUTF8StringEncoding]]; } while(0);

@interface Jack : NSObject

@property (class, strong, readonly, nonatomic) NSString *greetingString;

+ (void)wakeup;

@end
