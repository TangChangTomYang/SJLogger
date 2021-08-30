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

-(void)writeData:(NSData *)data{
    if(self.fileHandle == nil || data.length == 0){
        return ;
    }
    __weak  typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        [weakSelf.fileHandle writeData:data];
    });
}
 
-(void)writeLog:(SJLoggerModel *)model{
    NSData *data = [model toBytes];
    [self writeData:data];
}







@end
