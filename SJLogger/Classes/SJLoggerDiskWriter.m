//
//  SJLoggerDiskWriter.m
//  CinLogger_Example
//
//  Created by yangrui on 2021/8/30.
//  Copyright © 2021 tom. All rights reserved.
//

#import "SJLoggerDiskWriter.h"
#import "SJLoggerModel.h"

@implementation SJLoggerDiskWriter

 
-(void)writeLogModel2Disk:(SJLoggerModel *)model{
    __weak  typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        if(self.fileHandle == nil || model == nil){
            return ;
        }
        NSData *data = [model toBytes];
        if (weakSelf.fileHandle && data) {
            [weakSelf.fileHandle writeData:data];
        }
        
    });
}







@end
