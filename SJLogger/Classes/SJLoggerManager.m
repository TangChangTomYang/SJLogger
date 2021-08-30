//
//  SJLoggerManager.m
//  SJLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import "SJLoggerManager.h"

@interface SJLoggerManager ()

@property(nonatomic, strong)NSMutableDictionary *loggerDicM;
 
@end

@implementation SJLoggerManager

-(NSMutableDictionary *)loggerDicM{
    if (!_loggerDicM) {
        _loggerDicM =  [NSMutableDictionary dictionary];
    }
    return _loggerDicM;
}

+(SJLogger *)logger:(NSString *)name{
    NSString *nameStr = name;
    if (name.length == 0) {
        nameStr = @"SJLogger";
    }
    SJLogger *logger = [[SJLoggerManager shareInstance] loggerDicM][nameStr];
    if (logger == nil) {
        logger = [SJLogger loggerWithName:nameStr];
        [[self shareInstance] loggerDicM][nameStr] = logger;
    }
    return logger;
}

+(void)setLoggerOpen:(BOOL)open ofName:(NSString *)name{
    [[self logger:name] setOpen:open];
}

+(void)setLoggerNeedSaveLog2Disk:(BOOL)needSaveDisk  ofName:(NSString *)name{
    [[self logger:name] setNeedSaveLog2Disk:needSaveDisk];
}

+(instancetype)shareInstance{
    static SJLoggerManager *__SJLoggerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __SJLoggerManager = [[SJLoggerManager alloc] init];
    });
    return __SJLoggerManager;
    
    
}

@end
