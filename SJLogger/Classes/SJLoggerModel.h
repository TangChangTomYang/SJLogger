//
//  SJLoggerModel.h
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJLoggerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJLoggerModel : NSObject

@property (nonatomic, copy)   NSString *file;
@property (nonatomic, assign) int line;
@property (nonatomic, strong) NSString *func;
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSException *exception;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy)   NSString *threadName;
@property (nonatomic, assign) SJLoggerLevel level;

- (NSData *)toBytes;

- (NSString *)descriptionWithTime:(BOOL)time;
@end

NS_ASSUME_NONNULL_END
