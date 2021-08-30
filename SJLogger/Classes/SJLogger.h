//
//  SJLogger.h
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJLoggerDefine.h"




@interface SJLogger : NSObject

@property (nonatomic, assign) SJLoggerLevel level;

+(instancetype)loggerWithName:(NSString *)name;

#pragma mark- 日志开关
-(BOOL)isOpen;
-(void)setOpen:(BOOL)status;

-(BOOL)isNeedSaveLog2Disk;
-(void)setNeedSaveLog2Disk:(BOOL)saveDisk;

-(void)debug:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;
-(void)info:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;
-(void)warn:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...;
-(void)error:(const char *)file line:(int)line func:(const char *)func exception:(NSException *)ex format:(NSString *)format,...;


@end
 
