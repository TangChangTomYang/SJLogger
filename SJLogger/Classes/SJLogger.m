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
@property (nonatomic, strong) NSString *name;
@property(nonatomic, strong) SJLoggerDiskWriter *diskWriter;

@property(nonatomic, strong) NSString *openStatusKey;
@property(nonatomic, strong) NSString *saveLog2DiskKey;


@end

@implementation SJLogger

+(instancetype)loggerWithName:(NSString *)name{
    SJLogger *logger = [[SJLogger alloc] init];
    logger.level = SJLoggerLevel_Debug;
    logger.name = name;
    logger.openStatusKey = [NSString  stringWithFormat:@"%@_isOpen",logger.name];
    logger.saveLog2DiskKey =  [NSString  stringWithFormat:@"%@_needSaveLog2Dis", logger.name];
     
    [logger setOpen:YES];
    [logger setNeedSaveLog2Disk:YES];
    logger.diskWriter = [logger ceateDiskWriter];
    return logger;
    
}

-(NSString *)name{
    if (!_name) {
        _name = @"SJLogger";
    }
    return _name;
}

-(BOOL)isOpen{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:[self openStatusKey]];
}

-(void)setOpen:(BOOL)status{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[self openStatusKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isNeedSaveLog2Disk{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:[self saveLog2DiskKey]];
}

-(void)setNeedSaveLog2Disk:(BOOL)saveDisk{
    [[NSUserDefaults standardUserDefaults] setBool:saveDisk forKey:[self saveLog2DiskKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (saveDisk == YES) {
        [self.diskWriter writeData:[@"----------开始记录磁盘日志------" dataUsingEncoding:NSUTF8StringEncoding]];
    }
}







-(SJLoggerDiskWriter *)ceateDiskWriter{
    
    SJLoggerDiskWriter *diskWriter = [[SJLoggerDiskWriter alloc] init];
    
    diskWriter.queue = dispatch_queue_create([[NSString stringWithFormat:@"%@_logger_queue", self.name] UTF8String], nil);
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                     NSUserDomainMask, YES) objectAtIndex:0];
    
    // dir
    NSString *cachesLogsDirectory = [cachesDirectory stringByAppendingFormat:@"/logs"];
    BOOL isDirectory = YES;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:cachesLogsDirectory isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesLogsDirectory  withIntermediateDirectories:YES
                                                   attributes:nil error:nil];
    }
    
    // dir
    NSString *subDir = [cachesLogsDirectory stringByAppendingFormat:@"/%@_logs", self.name];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:subDir isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:subDir  withIntermediateDirectories:YES
                                                   attributes:nil error:nil];
    }
    
    // name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fileName = [NSString stringWithFormat:@"%@.txt",[formatter stringFromDate:[NSDate date]]];
    NSString *filePath = [subDir stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
       [[NSFileManager defaultManager] createFileAtPath:filePath  contents:nil
                                             attributes:@{NSFileProtectionKey:NSFileProtectionNone}];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    diskWriter.fileHandle = fileHandle;
    
    
    return diskWriter;
}

 



- (void)executeLog:(SJLoggerLevel)level
         exception:(NSException *)exception
              file:(const char *)file
              line:(int)line
              func:(const char *)func
           message:(NSString *)msg {
    
    if (![self isOpen]){
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
        
        // 打印控制台
        NSLog(@"%@", model);
        
        // 保存日志到磁盘
        if([self isNeedSaveLog2Disk]){
            [self.diskWriter writeLog:model];
        }
         
    }
}



-(void)debug:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    
    if (![self isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    
    [self executeLog:SJLoggerLevel_Debug exception:nil file:file line:line func:func message:msg];
    
}

-(void)info:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    
    if (![self isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [self executeLog:SJLoggerLevel_Info exception:nil file:file line:line func:func message:msg];
}

-(void)warn:(const char *)file line:(int)line func:(const char *)func format:(NSString *)format,...{
    if (![self isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [self executeLog:SJLoggerLevel_Warn exception:nil file:file line:line func:func message:msg];
}

-(void)error:(const char *)file line:(int)line func:(const char *)func exception:(NSException *)ex format:(NSString *)format,...{
    
    if (![self isOpen]){
        return;
    }
    va_list params;
    va_start(params, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:params];
    va_end(params);
    [self executeLog:SJLoggerLevel_Error exception:nil file:file line:line func:func message:msg];
    
}




@end
