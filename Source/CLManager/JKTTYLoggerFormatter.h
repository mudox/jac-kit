@import Foundation;
@import CocoaLumberjack;

@interface JKTTYLoggerFormatter : NSObject<DDLogFormatter>

+ (NSString * __nonnull)iconForFlag:(DDLogFlag)flag;

@end


