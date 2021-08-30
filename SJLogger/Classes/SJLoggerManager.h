//
//  SJLoggerManager.h
//  SJLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJLogger.h"


#ifndef SJLoggerManager_h
#define SJLoggerManager_h

    #define debugNameLog(name,...)           ([[SJLoggerManager logger:(name)] debug:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__])
    #define infoNameLog(name,...)            ([[SJLoggerManager logger:(name)] info:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__])
    #define warnNameLog(name,...)            ([[SJLoggerManager logger:(name)] warn:__FILE__ line:__LINE__ func:__func__ format:__VA_ARGS__])
    #define errorNameLog(name,exception,...) ([[SJLoggerManager logger:(name)] error:__FILE__ line:__LINE__ func:__func__ exception:exception format:__VA_ARGS__])

    #define debugLog(...)                   debugNameLog(nil,__VA_ARGS__)
    #define infoLog(name,...)               infoNameLog(nil,__VA_ARGS__)
    #define warnLog(name,...)               warnNameLog(nil,__VA_ARGS__)
    #define errorLog(name,exception,...)    errorNameLog(nil,exception,__VA_ARGS__)

#endif /* SJLoggerManager_h */
  
@interface SJLoggerManager : NSObject


+(SJLogger *)logger:(NSString *)name;

+(void)setLoggerOpen:(BOOL)open ofName:(NSString *)name;
+(void)setLoggerNeedSaveLog2Disk:(BOOL)needSaveDisk  ofName:(NSString *)name;
@end
 
