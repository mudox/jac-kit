//
// JKHTTPLogger.h
// Pods
//
// Created by Mudox on 12/06/2017.
//
//

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface JKHTTPLogger : DDAbstractLogger <DDLogger>

@property (class, strong, readonly, nonatomic) NSURL *_Nullable serverURL;
@property (class, strong, readonly, nonatomic) NSString *_Nullable sessionID;

@end




