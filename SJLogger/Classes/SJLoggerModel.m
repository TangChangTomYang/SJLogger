//
//  SJLoggerModel.m
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import "SJLoggerModel.h"

static NSDateFormatter *SJLoggerModelDateFormate__ = nil;
@implementation SJLoggerModel


- (NSData *)toBytes {
    return [[self description] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)description {
    return [self descriptionWithTime:YES];
}

- (NSString *)descriptionWithTime:(BOOL)time {
    
    NSMutableString *str = [[NSMutableString alloc] init];
    if (time) {
        [SJLoggerModel createDateFormatter];
        [str appendString:[SJLoggerModelDateFormate__ stringFromDate:self.date]];
    }
    
    [str appendFormat:@"[%@]", [self nameOfLogLevel:self.level]];
    [str appendFormat:@"[%@]'s line:(%d)\r\n", self.file.lastPathComponent, self.line];
    [str appendFormat:@"%@\r\n", self.msg];
    
    if (self.exception != nil) {
        [str appendFormat:@"Name: %@\r\n", self.exception.name];
        [str appendFormat:@"Reason: %@\r\n", self.exception.reason];
        [str appendFormat:@"StackTrace:\r\n"];
        [str appendFormat:@"%@\r\n", self.exception.callStackSymbols];
    }
    return str;
}

- (NSString *)nameOfLogLevel:(SJLoggerLevel)level {
    switch (level) {
        case SJLoggerLevel_Debug:
            return @"DEBUG";
        case SJLoggerLevel_Info:
            return @"INFO";
        case SJLoggerLevel_Warn:
            return @"WARN";
        case SJLoggerLevel_Error:
            return @"ERROR";
        default:
            return @"KNOWN";
    }
     
}

+ (void)createDateFormatter {
    if (SJLoggerModelDateFormate__ == nil) {
        @synchronized (self) {
            if (SJLoggerModelDateFormate__ == nil) {
                SJLoggerModelDateFormate__ = [[NSDateFormatter alloc] init];
                [SJLoggerModelDateFormate__ setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            }
        }
    }
}
@end
