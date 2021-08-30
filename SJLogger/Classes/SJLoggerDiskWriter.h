//
//  SJLoggerDiskWriter.h
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SJLoggerModel;

 
@interface SJLoggerDiskWriter : NSObject

@property(nonatomic, strong)dispatch_queue_t queue;
@property(nonatomic, strong)NSFileHandle *fileHandle;


-(void)writeLog:(SJLoggerModel *)model;
-(void)writeData:(NSData *)data;

@end

 
