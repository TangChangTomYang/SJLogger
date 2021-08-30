//
//  SJLogger.m
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import "SJLogger.h"
#import "SJLoggerModel.h"
#import "SJLoggerDiskWriter.h"

@interface SJLogger()
@property(nonatomic, strong) SJLoggerDiskWriter *diskWriter;
@end

@implementation SJLogger

+(BOOL)isOpen{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"SJLogger_isOpen"];
}

+(void)open:(BOOL)status{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"SJLogger_isOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)needSaveLog2Disk{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"SJLogger_needSaveLog2Disk"];
}

+(void)saveLog2Disk:(BOOL)saveDisk{
    [[NSUserDefaults standardUserDefaults] setBool:saveDisk forKey:@"SJLogger_needSaveLog2Disk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


 
+ (SJLogger *)shareInstance {
    static SJLogger *_loger = nil;
    static BOOL isFirstCreate = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loger = [[SJLogger alloc] init];
        _loger.diskWriter = [self ceateDiskWriter];
    });
    if (isFirstCreate == YES) {
        isFirstCreate = NO;
        debugLog(@"==============开始记录日志===========");
    }
    
    return _loger;
}
 




- (void)executeLog:(SJLoggerLevel)level
         exception:(NSException *)exception
              file:(const char *)file
              line:(int)line
              func:(const char *)func
           message:(NSString *)msg {
    
    if (![SJLogger isOpen]){
        return;
    }
    
    if (level < self.level) {
        return;
    }
    @autoreleasepool {
        SJLoggerModel *model = [[SJLoggerModel alloc] init];
        model.file = [NSString stringWithUTF8String:file];
        model.line = line;
        model.func = [NSString stringWithUTF8String:func];
        model.msg = msg;
        model.exception = exception;
        model.level = level;
        model.date = [NSDate date];
        
        NSString *threadName = [[NSThread currentThread] name];
        if (threadName == nil || [threadName isEqualToString:@""])
            [model setThreadName:[NSString stringWithFormat:@"%@", [NSThread currentThread]]];
        else
            [model setThreadName:threadName];
        
        NSLog(@"%@", model);
        
        if([SJLogger needSaveLog2Disk]){
            [self.diskWriter writeLogModel2Disk:model];
        }
         
    }
}



+(void)debug:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    
    if (![SJLogger isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    
    [[SJLogger shareInstance] executeLog:SJLoggerLevel_Debug exception:nil file:file line:line func:func message:msg];
    
}

+(void)info:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    
    if (![SJLogger isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [[SJLogger shareInstance] executeLog:SJLoggerLevel_Info exception:nil file:file line:line func:func message:msg];
}

+(void)warn:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    if (![SJLogger isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [[SJLogger shareInstance] executeLog:SJLoggerLevel_Warn exception:nil file:file line:line func:func message:msg];
}

+(void)error:(const char *)file line:(int)line func:(const char *)func exception:(NSException *)ex format:(NSString *)format,...{
    
    if (![SJLogger isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [[SJLogger shareInstance] executeLog:SJLoggerLevel_Error exception:nil file:file line:line func:func message:msg];
    
}


+(SJLoggerDiskWriter *)ceateDiskWriter{
    SJLoggerDiskWriter *diskWriter = [[SJLoggerDiskWriter alloc] init];
    diskWriter.queue = dispatch_queue_create("SJLogger_diskWriter_Queue", nil);
    diskWriter.fileHandle = [self createDiskFileHandle];
    return diskWriter;
}

+(NSFileHandle *)createDiskFileHandle{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *diskDirectory = [dir stringByAppendingFormat:@"/%@", @"logs"];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskDirectory  withIntermediateDirectories:YES
                                                attributes:nil error:nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *filePath = [diskDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",time]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath  contents:nil
                                              attributes:@{NSFileProtectionKey:NSFileProtectionNone}];
     }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    return fileHandle;
}


@end
