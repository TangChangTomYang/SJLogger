//
//  SJLogger.h
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJLoggerDefine.h"



#ifndef SJLogger_h
#define SJLogger_h

    #define debugLog(...)   (([SJLogger isOpen] == YES) ?  [SJLogger debug:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__] : @"")
    #define infoLog(...)    (([SJLogger isOpen] == YES) ?  [SJLogger info:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__] : @"")
    #define warnLog(...)    (([SJLogger isOpen] == YES) ?  [SJLogger warn:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__] : @"")
    #define errorLog(e,...) (([SJLogger isOpen] == YES) ?  [SJLogger error:__FILE__ line:__LINE__ func:__func__ exception:e format:__VA_ARGS__] : @"")

#endif /* SJLogger_h */
 
 


@interface SJLogger : NSObject

@property (nonatomic, assign) SJLoggerLevel level;

#pragma mark- 日志开关
+(BOOL)isOpen;
+(void)open:(BOOL)status;

#pragma mark- 日志保存磁盘开关
+(BOOL)needSaveLog2Disk;
+(void)saveLog2Disk:(BOOL)saveDisk;

 
+(void)debug:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;

+(void)info:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;

+(void)warn:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;

+(void)error:(const char *)file line:(int)line func:(const char *)func exception:(NSException *)ex format:(NSString *)format,...;


@end
 
