//
//  JKFileManager.m
//  Pods
//
//  Created by Mudox on 14/04/2017.
//
//

#import "JKFileManager.h"

@interface JKFileManager ()

@end

@implementation JKFileManager

NSString *_logFileName = @"Jack.log";

- (NSString *)newLogFileName {
  return _logFileName;
}

- (BOOL)isLogFile:(NSString *)fileName {
  return [fileName isEqualToString:_logFileName];
}

@end
